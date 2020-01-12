#include "pch.h"
#include "Hooks.h"
#include "Menu.h"
#include "vmt.h"
#include "Scan.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Hacks.h"
#include "LuaAPI.h"
#include <intrin.h>
#include <iostream>

typedef void(__fastcall* f_CallUI)(__int64 skillClass, int a2);
f_CallUI callUI = (f_CallUI)(0x393a20b0);

typedef float(__fastcall* f_GetWaterLevel)(void* cry3DEngine, void* referencePOS);
typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);
typedef HRESULT(__stdcall* f_D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);
typedef __int64(__fastcall* f_GetNavPath_and_Move)(UINT_PTR* ActorUnit, Vec3* EndPosition);
typedef void*(__fastcall* f_RetrieveDoodadPosition)(ClientDoodad* doodad, void* unk1, void* newPosition, void* unk2);

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

f_EncryptPacket o_EncryptPacket = NULL;
f_GetWaterLevel o_GetWaterLevel = NULL;
f_D3D11PresentHook phookD3D11Present = NULL;
f_GetNavPath_and_Move o_GetNavPath_and_Move = NULL;
f_RetrieveDoodadPosition o_RetrieveDoodadPosition = NULL;

Detour64 detours;

Vec3 pathPosition_DoNotModify = {4500.0f, 4959.0f, 125.0f};

bool g_ShowMenu = false;
std::vector<int32_t> idList;

HRESULT GetDeviceAndCtxFromSwapchain(IDXGISwapChain* pSwapChain, ID3D11Device** ppDevice, ID3D11DeviceContext** ppContext)
{
	HRESULT ret = pSwapChain->GetDevice(__uuidof(ID3D11Device), (PVOID*)ppDevice);

	if (SUCCEEDED(ret))
		(*ppDevice)->GetImmediateContext(ppContext);

	return ret;
}


void TestMovementSpeed()
{
	// Set auto pathing on
	*Patterns.Addr_isAutoPathing = (BYTE)1;

	UINT_PTR LocalUnit = *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);

	if (!LocalUnit)
	{
		console.AddLog("Local Unit failed\n");
		return;
	}

	UINT_PTR* ActorUnitModel = *(UINT_PTR**)(LocalUnit + Patterns.Offset_ActorUnitModel);

	auto v5 = (*(__int64(__fastcall**)(__int64))(*(INT64*)ActorUnitModel + 0x470))((__int64)ActorUnitModel);
	auto v6 = (float*)v5;

	if (!v6)
	{
		console.AddLog("v6 is not valid\n");
		return;
	}

	__int64 v8;

	auto v7 = *(int*)(v5 + 128);
	if ((unsigned int)v7 > 9)
		v8 = (__int64)(v6 + 336);
	else
		v8 = (__int64)&v6[21 * v7 + 357];

	float BaseSpeed = v6[295];

	v6[295] = 20.0f;

	float bonusSPeed = *(float*)(v8 + 0x2C);

	auto totalSpeed = BaseSpeed * bonusSPeed;

	console.AddLog("base %f  bonus %f  total %f\n", BaseSpeed, bonusSPeed, totalSpeed);

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
		if (wParam == VK_INSERT)
		{
			g_ShowMenu = !g_ShowMenu;
		}

		if (wParam == VK_NUMPAD1)
		{
			TestMovementSpeed();
		}

		if (wParam == VK_HOME)
			Unload();
	}

	if (g_ShowMenu)
	{
		ImGui_ImplWin32_WndProcHandler(hWnd, uMsg, wParam, lParam);
		//return true;
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


	Patterns.Offset_Swapchain = (DWORD)Scan_Offsets((char*)HdnGetModuleBase("CryRenderD3D10.dll"), 0x200000, "\x48\x8b\x8b\xCC\xCC\xCC\x00\x48\x8b\x01\xff\x50\x40\x8b\xf8\x3d\x21\x00\x7a\x88", "xxx???xxxxxxxxxxxxxx", 3, 4);

	if (!Patterns.Offset_Swapchain)
	{
		printf("[Error] Patterns.Offset_Swapchain failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_Swapchain is at %llx\n", (UINT_PTR)Patterns.Offset_Swapchain); };

	Patterns.Offset_LocalUnit = (DWORD)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x200000, "\x48\x8b\xb0\xCC\xCC\x00\x00\x48\x85\xf6\x75\xCC\x32\xc0\x48\x81\xc4", "xxx??xxxxxx?xxxxx", 3, 4);

	if (!Patterns.Offset_LocalUnit)
	{
		printf("[Error] Patterns.Offset_LocalUnit failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_LocalUnit is at %llx\n", (UINT_PTR)Patterns.Offset_LocalUnit); };

	Patterns.Offset_ActorUnitModel = (UINT_PTR)Scan_Offsets((char*)HdnGetModuleBase("x2game.dll"), 0x300000, "\x48\x83\xec\x28\x48\x8b\x89\xCC\xCC\x00\x00\x48\x8b\x01\xff\x90\xCC\xCC\x00\x00\xf3\x0f\x10\x40", "xxxxxxx??xxxxxxx??xxxxxx", 7, 4);

	if (!Patterns.Offset_ActorUnitModel)
	{
		printf("[Error] Patterns.Offset_ActorUnitModel failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_ActorUnitModel is at %llx\n", (UINT_PTR)Patterns.Offset_ActorUnitModel); };

	Patterns.Func_EncryptPacket = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("CryNetwork.dll"), 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_EncryptPacket)
	{
		printf("[Error] Patterns.Func_EncryptPacket failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_EncryptPacket is at %llx\n", Patterns.Func_EncryptPacket); };

	Patterns.Func_UpdateSwimCaller = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x500000, "\x0f\x28\xc8\xf3\x0f\x5c\xCC\xCC\x00\x00\x00\x41\x0f\x2f\xcc", "xxxxxx??xxxxxxx");

	if (!Patterns.Func_UpdateSwimCaller)
	{
		printf("[Error] Patterns.Func_UpdateSwimCaller failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_UpdateSwimCaller is at %llx\n", Patterns.Func_UpdateSwimCaller); };

	Patterns.Func_GetSetNavPath = (UINT_PTR)PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x500000, "\x48\x8b\xc4\x57\x48\x83\xec\x60\x48\xc7\x44\x24\x20\xfe\xff\xff\xff\x48\x89\x58\x10\x48\x89\x68\x18\x48\x89\x70\x20\x48\x8b\xf2\x48\x8b\xd9", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_GetSetNavPath)
	{
		printf("[Error] Patterns.Func_GetSetNavPath failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetSetNavPath is at %llx\n", Patterns.Func_GetSetNavPath); };


	return TRUE;
}

DWORD __stdcall InitializeHooks()
{
	hWnd = FindWindowEx(0, 0, L"ArcheAge", 0);

	findPatterns();

	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + Patterns.Offset_Swapchain); // offset_Swapchain =  0x159e0

	dx_swapchain.vmt = ((void**)pSwapChainVtable);

	phookD3D11Present = (f_D3D11PresentHook)dx_swapchain.Hook(8, hookD3D11Present);

	LocateLuaFunctions();	

	o_EncryptPacket = (f_EncryptPacket)Patterns.Func_EncryptPacket;
	o_EncryptPacket = (f_EncryptPacket)detours.Hook(o_EncryptPacket, h_EncryptPacket, 14);

	DWORD_PTR* p3DEngineVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->p3DEngine;
	vGetWaterLevel.vmt = (void**)p3DEngineVtable;
	o_GetWaterLevel = (f_GetWaterLevel)vGetWaterLevel.Hook(71, h_GetWaterLevel);

	o_GetNavPath_and_Move = (f_GetNavPath_and_Move)Patterns.Func_GetSetNavPath;

	o_RetrieveDoodadPosition = (f_RetrieveDoodadPosition)0x399DCC90;
	o_RetrieveDoodadPosition = (f_RetrieveDoodadPosition)detours.Hook(o_RetrieveDoodadPosition, h_RetrieveDoodadPosition, 15);

	return NULL;
}

bool __stdcall Unload()
{
	ToggleNoFall(false);
	SetPlayerSpeed(1.0f);
	if (detours.Clearhook())
	{
		dx_swapchain.ClearHooks();
		vGetWaterLevel.ClearHooks();
		SetWindowLongPtr(window, GWLP_WNDPROC, (LONG_PTR)OriginalWndProcHandler);
		FreeLibrary(h_Module);
		UnmapViewOfFile(h_Module);
		return true;
	}

	return false;
}