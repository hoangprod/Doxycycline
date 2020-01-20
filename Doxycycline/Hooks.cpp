#include "pch.h"
#include "Hooks.h"
#include "Menu.h"
#include "vmt.h"
#include "Scan.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Hacks.h"
#include "LuaAPI.h"
#include "Combat.h"
#include <intrin.h>
#include <iostream>

typedef float(__fastcall* f_GetWaterLevel)(void* cry3DEngine, void* referencePOS);
typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);
typedef HRESULT(__stdcall* f_D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);
typedef __int64(__fastcall* f_GetNavPath_and_Move)(UINT_PTR* ActorUnit, Vec3* EndPosition);
typedef void*(__fastcall* f_RetrieveDoodadPosition)(ClientDoodad* doodad, void* unk1, void* newPosition, void* unk2);
typedef void*(__fastcall* f_EndCall)(IScriptSystem* scriptSys);

extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
extern packetCrypto packetinfo;

ID3D11Device* pDevice = NULL;
ID3D11DeviceContext* pContext = NULL;

static IDXGISwapChain* pSwapChain = NULL;
static WNDPROC OriginalWndProcHandler = nullptr;

ID3D11RenderTargetView* mainRenderTargetView;

HWND window = nullptr;
HWND hWnd = nullptr;
Addr Patterns;

VMTHook dx_swapchain;
VMTHook vGetWaterLevel;
VMTHook vEndCall;

f_EncryptPacket o_EncryptPacket = NULL;
f_GetWaterLevel o_GetWaterLevel = NULL;
f_D3D11PresentHook phookD3D11Present = NULL;
f_GetNavPath_and_Move o_GetNavPath_and_Move = NULL;
f_RetrieveDoodadPosition o_RetrieveDoodadPosition = NULL;
f_EndCall o_EndCall = NULL;

Detour64 detours;

Vec3 pathPosition_DoNotModify = {4500.0f, 4959.0f, 125.0f};

bool g_ShowMenu = false;
bool g_HijackCtrl = false;

std::vector<int32_t> idList;

HRESULT GetDeviceAndCtxFromSwapchain(IDXGISwapChain* pSwapChain, ID3D11Device** ppDevice, ID3D11DeviceContext** ppContext)
{
	HRESULT ret = pSwapChain->GetDevice(__uuidof(ID3D11Device), (PVOID*)ppDevice);

	if (SUCCEEDED(ret))
		(*ppDevice)->GetImmediateContext(ppContext);

	return ret;
}

bool PathToPosition(Vec3 Position)
{
	// Set auto pathing on
	*Patterns.Addr_isAutoPathing = (BYTE)1;

	UINT_PTR LocalUnit = *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);

	if (!LocalUnit)
	{
		console.AddLog("Local Unit failed\n");
		return false;
	}
	
	UINT_PTR * ActorUnitModel = *(UINT_PTR**)(LocalUnit + Patterns.Offset_ActorUnitModel);	

	if (!ActorUnitModel)
	{
		console.AddLog("ActorUnitModel failed.\n");
		return false;
	}
	
	o_GetNavPath_and_Move(ActorUnitModel, &Position);

	return true;
}

void* h_EndCall(IScriptSystem* scriptSys) // this is the method where we will exeucte lua
{
	return o_EndCall(scriptSys);
}

void* h_RetrieveDoodadPosition(ClientDoodad* doodad, void* unk1, void* newPosition, void* unk2)
{
	void* returnValue = o_RetrieveDoodadPosition(doodad, unk1, newPosition, unk2);
	if (std::find(idList.begin(), idList.end(), doodad->ID) != idList.end())
	{
		
	}

	else
	{
		std::cout << "doodad ID: " << doodad->ID << std::endl;
		idList.push_back(doodad->ID);
	}
	return returnValue;
}

float __fastcall h_GetWaterLevel(void* cry3DEngine, void* referencePOS)
{

	if (bFlyHack && Patterns.Func_UpdateSwimCaller)
	{
		void* address = _ReturnAddress();
		if (address == (void*)Patterns.Func_UpdateSwimCaller)
		{
			Vec3 pos = LocalPlayerFinder::GetClientEntity()->GetPos();
			return pos.y + 15.f;
		}
	}
	
	return o_GetWaterLevel(cry3DEngine, referencePOS);
}

bool __fastcall h_EncryptPacket(__int64* Buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer)
{
	packetinfo.sUnknown = Buffer;
	packetinfo.sClear = cleartextbuffer;

	if (isEncrypted == 1)
	{
		peditor.Push((UINT_PTR)key);
	}

	return o_EncryptPacket(Buffer, isEncrypted, key, cleartextbuffer);
}



LRESULT CALLBACK hWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	ImGuiIO& io = ImGui::GetIO();
	POINT mPos;
	GetCursorPos(&mPos);
	ScreenToClient(window, &mPos);
	ImGui::GetIO().MousePos.x = mPos.x;
	ImGui::GetIO().MousePos.y = mPos.y;

	if (uMsg == WM_KEYUP)
	{
		if (wParam == VK_OEM_3)
		{
			g_ShowMenu = !g_ShowMenu;
		}

		if (wParam == VK_NUMPAD6)
		{

		}
		if (wParam == VK_NUMPAD7)
		{
			Combat combat;
			auto list = combat.get_aggro_mob_list();

			printf("list count: %d\n", list.size());

		}
		if (wParam == VK_CONTROL)
		{
			g_HijackCtrl = !g_HijackCtrl;
		}

		if (wParam == VK_HOME)
			Unload();
	}

	if (g_ShowMenu)
	{
		ImGui_ImplWin32_WndProcHandler(hWnd, uMsg, wParam, lParam);

		if (g_HijackCtrl)
			return true;
	}

	return CallWindowProc(OriginalWndProcHandler, hWnd, uMsg, wParam, lParam);
}

HRESULT __fastcall hookD3D11Present(IDXGISwapChain* pChain, UINT SyncInterval, UINT Flags)
{
	static bool firstTime = true;

	if (firstTime) {
		if (FAILED(GetDeviceAndCtxFromSwapchain(pChain, &pDevice, &pContext)))
			return phookD3D11Present(pChain, SyncInterval, Flags);
		pSwapChain = pChain;
		DXGI_SWAP_CHAIN_DESC sd;
		pChain->GetDesc(&sd);
		ImGui::CreateContext();
		ImGuiIO& io = ImGui::GetIO(); (void)io;
		io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
		window = sd.OutputWindow;

		//Set OriginalWndProcHandler to the Address of the Original WndProc function
		OriginalWndProcHandler = (WNDPROC)SetWindowLongPtr(window, GWLP_WNDPROC, (LONG_PTR)hWndProc);

		ImGui_ImplWin32_Init(window);
		ImGui_ImplDX11_Init(pDevice, pContext);
		ImGui::GetIO().ImeWindowHandle = window;

		ID3D11Texture2D* pBackBuffer;

		pChain->GetBuffer(0, __uuidof(ID3D11Texture2D), (LPVOID*)&pBackBuffer);
		pDevice->CreateRenderTargetView(pBackBuffer, NULL, &mainRenderTargetView);
		pBackBuffer->Release();
		firstTime = false;
	}
	ImGui_ImplWin32_NewFrame();
	ImGui_ImplDX11_NewFrame();

	ImGui::NewFrame();

	if (g_ShowMenu)
	{
		MenuRender();
	}
	ImGui::EndFrame();

	ImGui::Render();

	pContext->OMSetRenderTargets(1, &mainRenderTargetView, NULL);
	ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());

	return phookD3D11Present(pChain, SyncInterval, Flags);
}

BOOLEAN __stdcall findPatterns()
{
	printf("------------------ [ START PATTERN SCAN ] ------------------\n\n");

	//////////////////////////////////////////////////////////////////[ STATIC ADDRESSES ]///////////////////////////////////////////////////////////////////////////////

	printf("------------------ [ STATIC ADDRESSES ] ------------------\n\n");

	Patterns.Addr_isAutoPathing = (BYTE*)ptr_offset_Scanner((char*)HdnGetModuleBase("x2game.dll"), 0x300000, "\xc6\x05\xCC\xCC\xCC\x01\x01\xe8\xCC\xCC\xCC\xCC\x84\xc0", 0, 6, 2, "xx???xxx????xx") + 1; // + 1 because its a weird write instruction

	if (!Patterns.Addr_isAutoPathing)
	{
		printf("[Error] Patterns.Addr_isAutoPathing failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_isAutoPathing is at %llx\n", (UINT_PTR)Patterns.Addr_isAutoPathing); };

	Patterns.Addr_SpeedModifier = (FLOAT*)ptr_offset_Scanner((char*)HdnGetModuleBase("crysystem.dll"), 0x100000, "\xf3\x44\xCC\xCC\xCC\xCC\xCC\xCC\x00\x84\xc0\x0f\x84\xCC\x00\x00\x00\x48\x8b\x06\x48\x8b\xce", 0, 9, 5, "xx??????xxxxx?xxxxxxxxx");

	if (!Patterns.Addr_SpeedModifier)
	{
		printf("[Error] Patterns.Addr_SpeedModifier failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_SpeedModifier is at %llx\n", (UINT_PTR)Patterns.Addr_SpeedModifier); };

	Patterns.Addr_gEnv = (UINT_PTR)ptr_offset_Scanner((char*)HdnGetModuleBase("x2game.dll"), 0x100000, "\x48\x8b\x05\xCC\xCC\xCC\xCC\x80\xb8\xCC\xCC\x00\x00\x00\x74\xCC\x48", 0, 7, 3, "xxx????xx??xxxx?x");

	if (!Patterns.Addr_gEnv)
	{
		printf("[Error] Patterns.Addr_gEnv failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_gEnv is at %llx\n", (UINT_PTR)Patterns.Addr_gEnv); };

	Patterns.Addr_UnitClass = (UINT_PTR)ptr_offset_Scanner((char*)HdnGetModuleBase("x2game.dll"), 0x200000, "\x48\x8b\x05\xCC\xCC\xCC\x00\x44\x8b\xf1\x48\x8b\xb0\xCC\xCC\x00\x00", 0, 7, 3, "xxx???xxxxxxx??xx");

	if (!Patterns.Addr_UnitClass)
	{
		printf("[Error] Patterns.Addr_UnitClass failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_UnitClass is at %llx\n", (UINT_PTR)Patterns.Addr_UnitClass); };



	//////////////////////////////////////////////////////////////////[ OFFSETS ]///////////////////////////////////////////////////////////////////////////////

	printf("\n------------------ [ OFFSETS ] ------------------\n\n");


	Patterns.Offset_Swapchain = (DWORD)Scan_Offsets((char*)HdnGetModuleBase("CryRenderD3D10.dll"), 0x300000, "\x48\x8b\x8b\xCC\xCC\xCC\x00\x48\x8b\x01\xff\x50\x40\x8b\xf8\x3d\x21\x00\x7a\x88", "xxx???xxxxxxxxxxxxxx", 3, 4);

	if (!Patterns.Offset_Swapchain)
	{
		printf("[Error] Patterns.Offset_Swapchain failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_Swapchain is at %llx\n", (UINT_PTR)Patterns.Offset_Swapchain); };

	Patterns.Offset_LocalUnit = (DWORD)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x8b\xb0\xCC\xCC\x00\x00\x48\x85\xf6\x75\xCC\x32\xc0\x48\x81\xc4", "xxx??xxxxxx?xxxxx", 3, 4);

	if (!Patterns.Offset_LocalUnit)
	{
		printf("[Error] Patterns.Offset_LocalUnit failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_LocalUnit is at %llx\n", (UINT_PTR)Patterns.Offset_LocalUnit); };

	Patterns.Offset_ActorUnitModel = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x83\xec\x28\x48\x8b\x89\xCC\xCC\x00\x00\x48\x8b\x01\xff\x90\xCC\xCC\x00\x00\xf3\x0f\x10\x40", "xxxxxxx??xxxxxxx??xxxxxx", 7, 4);

	if (!Patterns.Offset_ActorUnitModel)
	{
		printf("[Error] Patterns.Offset_ActorUnitModel failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_ActorUnitModel is at %llx\n", (UINT_PTR)Patterns.Offset_ActorUnitModel); };

	Patterns.Offset_UserStats = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x83\xec\x38\x48\x8b\x89\xCC\xCC\x00\x00\xf3\x0f\x11\x4c\xCC\xCC\xf3\x0f\x11\x4c", "xxxxxxx??xxxxxx??xxxx", 7, 4);

	if (!Patterns.Offset_UserStats)
	{
		printf("[Error] Patterns.Offset_UserStats failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_UserStats is at %llx\n", (UINT_PTR)Patterns.Offset_UserStats); };


	Patterns.Offset_SpeedStat = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\xF3\x0F\x10\xB3\xCC\xCC\x00\x00\x48\x8B\xCB\xF3\x0F\x59\xCC\xCC\xE8", "xxxx??xxxxxxxx??x", 4, 4);

	if (!Patterns.Offset_SpeedStat)
	{
		printf("[Error] Patterns.Offset_SpeedStat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_SpeedStat is at %llx\n", (UINT_PTR)Patterns.Offset_SpeedStat); };

	Patterns.Offset_CurrentTargetId = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x8b\x80\xCC\xCC\x00\x00\xeb\xCC\x40\x32\xf6\x8b\x05\xCC\xCC\xCC\x03", "xx??xxx?xxxxx???x", 2, 4);

	if (!Patterns.Offset_CurrentTargetId)
	{
		printf("[Error] Patterns.Offset_CurrentTargetId failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_CurrentTargetId is at %llx\n", (UINT_PTR)Patterns.Offset_CurrentTargetId); };


	Patterns.Offset_isInCombat = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x0f\xb6\x81\xCC\xCC\x00\x00\xc7\x44\x24\x28\x02\x00\x00\x00", "xxx??xxxxxxxxxx", 3, 4);

	if (!Patterns.Offset_isInCombat)
	{
		printf("[Error] Patterns.Offset_isInCombat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_isInCombat is at %llx\n", (UINT_PTR)Patterns.Offset_isInCombat); };

	//////////////////////////////////////////////////////////////////[ FUNCTIONS ]///////////////////////////////////////////////////////////////////////////////

	printf("\n------------------ [ FUNCTIONS ] ------------------\n\n");

	Patterns.Offset_IsUnitInCombat = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x80\xB9\x00\x00\x00\x00\x00\x75\x12\x48\x8B\x01", "xx?????xxxxx", 2, 4);

	if (!Patterns.Offset_IsUnitInCombat)
	{
		printf("[Error] Patterns.Offset_IsUnitInCombat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_IsUnitInCombat is at %llx\n", (UINT_PTR)Patterns.Offset_IsUnitInCombat); };

	//////////////////////////////////////////////////////////////////[ FUNCTIONS ]///////////////////////////////////////////////////////////////////////////////

	Patterns.Func_EncryptPacket = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("CryNetwork.dll"), 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_EncryptPacket)
	{
		printf("[Error] Patterns.Func_EncryptPacket failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_EncryptPacket is at %llx\n", Patterns.Func_EncryptPacket); };

	Patterns.Func_UpdateSwimCaller = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x0f\x28\xc8\xf3\x0f\x5c\xCC\xCC\x00\x00\x00\x41\x0f\x2f\xcc", "xxxxxx??xxxxxxx");

	if (!Patterns.Func_UpdateSwimCaller)
	{
		printf("[Error] Patterns.Func_UpdateSwimCaller failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_UpdateSwimCaller is at %llx\n", Patterns.Func_UpdateSwimCaller); };

	Patterns.Func_GetSetNavPath = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x8b\xc4\x57\x48\x83\xec\x60\x48\xc7\x44\x24\x20\xfe\xff\xff\xff\x48\x89\x58\x10\x48\x89\x68\x18\x48\x89\x70\x20\x48\x8b\xf2\x48\x8b\xd9", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_GetSetNavPath)
	{
		printf("[Error] Patterns.Func_GetSetNavPath failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetSetNavPath is at %llx\n", Patterns.Func_GetSetNavPath); };

	Patterns.Func_GetClientUnit = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x3b\x0d\xCC\xCC\xCC\xCC\x74\xCC\x4c\x8b\x05\xCC\xCC\xCC\x03\x49\x8b\xd0", "xx????x?xxx???xxxx");

	if (!Patterns.Func_GetClientUnit)
	{
		printf("[Error] Patterns.Func_GetClientUnit failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetClientUnit is at %llx\n", Patterns.Func_GetClientUnit); };

	Patterns.Func_CastSkillWrapper = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x89\x5c\x24\x18\x48\x89\x74\x24\x20\x89\x54\x24\x10\x55\x57\x41\x54", "xxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_CastSkillWrapper)
	{
		printf("[Error] Patterns.Func_CastSkillWrapper failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_CastSkillWrapper is at %llx\n", Patterns.Func_CastSkillWrapper); };

	Patterns.Func_AI_IsCasting = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x4C\x8B\xD8\x48\x85\xC0\x75\x05\x48\x83\xC4\x28\xC3\x8B\x05\x00\x00\x00\x00\x41\x39\x83\x00\x00\x00\x00\x75\x16", "xxxxxxx????xxxxxxxxxxxxxxx????xxx????xx");

	if (!Patterns.Func_AI_IsCasting)
	{
		printf("[Error] Patterns.Func_AI_IsCasting failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_IsCasting is at %llx\n", Patterns.Func_AI_IsCasting); };

	Patterns.Func_AI_StopCasting = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x89\x54\x24\x10\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x48\x85\xC0\x74\x51\x48\x8B\x05\x00\x00\x00\x00\x48\x83\xB8\x00\x00\x00\x00\x00\x74\x15\x48\x8B\x80\x00\x00\x00\x00\x8B\x48\x08\x48\x8D\x44\x24\x00\x89\x4C\x24\x40", "xxxxxxxxxxx????xxxxxxxx????xxx?????xxxxx????xxxxxxx?xxxx");

	if (!Patterns.Func_AI_StopCasting)
	{
		printf("[Error] Patterns.Func_AI_StopCasting failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_StopCasting is at %llx\n", Patterns.Func_AI_StopCasting); };

	Patterns.Func_AI_IsChanneling = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x4C\x8B\xD8\x48\x85\xC0\x75\x05\x48\x83\xC4\x28\xC3\x8B\x80\x00\x00\x00\x00", "xxxxxxx????xxxxxxxxxxxxxxx????");

	if (!Patterns.Func_AI_IsChanneling)
	{
		printf("[Error] Patterns.Func_AI_IsChanneling failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_IsChanneling is at %llx\n", Patterns.Func_AI_IsChanneling); };

	Patterns.Func_AI_GetGlobalCooldown = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x44\x89\x44\x24\x00\x48\x83\xEC\x38\x8B\xCA", "xxxx?xxxxxx");

	if (!Patterns.Func_AI_GetGlobalCooldown)
	{
		printf("[Error] Patterns.Func_AI_GetGlobalCooldown failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_GetGlobalCooldown is at %llx\n", Patterns.Func_AI_GetGlobalCooldown); };


	Patterns.Func_GetIndexVelocity = (UINT_PTR)ptr_offset_Scanner((char*)HdnGetModuleBase("x2game.dll"), 0x200000, "\xe8\xCC\xCC\xCC\x00\x0f\x57\xf6\xf3\x0f\x59\x05\xCC\xCC\xCC\x00", 0, 5, 1, "x???xxxxxxxx???x");

	if (!Patterns.Func_GetIndexVelocity)
	{
		printf("[Error] Patterns.Func_GetIndexVelocity failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetIndexVelocity is at %llx\n", (UINT_PTR)Patterns.Func_GetIndexVelocity); };

	printf("\n------------------ [ END PATTERN SCAN ] ------------------\n\n");

	Patterns.Func_AI_CheckBuff = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x800000, "\x44\x89\x44\x24\x00\x48\x83\xEC\x28\x8B\xCA", "xxxx?xxxxxx");

	if (!Patterns.Func_AI_CheckBuff)
	{
		printf("[Error] Patterns.Func_AI_CheckBuff failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_CheckBuff is at %llx\n", Patterns.Func_AI_CheckBuff); };

	return TRUE;
}

DWORD __stdcall InitializeHooks()
{
	hWnd = FindWindowEx(0, 0, L"ArcheAge", 0);

	findPatterns();

	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + Patterns.Offset_Swapchain);

	dx_swapchain.vmt = ((void**)pSwapChainVtable);

	phookD3D11Present = (f_D3D11PresentHook)dx_swapchain.Hook(8, hookD3D11Present);

	LocateLuaFunctions();	

	o_EncryptPacket = (f_EncryptPacket)Patterns.Func_EncryptPacket;
	o_EncryptPacket = (f_EncryptPacket)detours.Hook(o_EncryptPacket, h_EncryptPacket, 14);

	DWORD_PTR* p3DEngineVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->p3DEngine;
	vGetWaterLevel.vmt = (void**)p3DEngineVtable;
	o_GetWaterLevel = (f_GetWaterLevel)vGetWaterLevel.Hook(71, h_GetWaterLevel);

	DWORD_PTR* pScriptSysVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->pScriptSysOne;
	vEndCall.vmt = (void**)pScriptSysVtable;
	o_EndCall = (f_EndCall)vEndCall.Hook(17, h_EndCall);

	o_GetNavPath_and_Move = (f_GetNavPath_and_Move)Patterns.Func_GetSetNavPath;

	return NULL;
}

bool __stdcall Unload()
{
	ToggleNoFall(false);
	SetPlayerStatSpeed(1.0f);
	SetPlayerAnimationSpeed(1.0f);
	if (detours.Clearhook())
	{
		//FreeConsole();
		dx_swapchain.ClearHooks();
		vGetWaterLevel.ClearHooks();
		vEndCall.ClearHooks();
		SetWindowLongPtr(window, GWLP_WNDPROC, (LONG_PTR)OriginalWndProcHandler);
		FreeLibrary(h_Module);
		UnmapViewOfFile(h_Module);
		return true;
	}

	return false;
}