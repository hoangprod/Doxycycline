#include "pch.h"
#include "Hooks.h"
#include "vmt.h"
#include "Scan.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Menu.h"
#include "Hacks.h"
#include "LuaAPI.h"
#include "Combat.h"
#include "Patterns.h"
#include "Inventory.h"
#include "Skills.h"
#include "Game.h"

typedef float(__fastcall* f_GetWaterLevel)(void* cry3DEngine, void* referencePOS);
typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);
typedef UINT_PTR(__fastcall* f_EncryptSendPacket)(UINT_PTR localPlayer, UINT_PTR packetBody);
typedef HRESULT(__stdcall* f_D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);
typedef void*(__fastcall* f_EndCall)(IScriptSystem* scriptSys);

extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
extern packetCrypto packetinfo;
extern Addr Patterns;

ID3D11Device* pDevice = NULL;
ID3D11DeviceContext* pContext = NULL;

static IDXGISwapChain* pSwapChain = NULL;
static WNDPROC OriginalWndProcHandler = nullptr;

ID3D11RenderTargetView* mainRenderTargetView;

HWND window = nullptr;
HWND hWnd = nullptr;

VMTHook dx_swapchain;
VMTHook vGetWaterLevel;
VMTHook vEndCall;

f_EncryptPacket o_EncryptPacket = NULL;
f_EncryptSendPacket o_Encrypt_Send = NULL;
f_GetWaterLevel o_GetWaterLevel = NULL;
f_D3D11PresentHook phookD3D11Present = NULL;
f_EndCall o_EndCall = NULL;

Detour64 detours;

Vec3 pathPosition_DoNotModify = {4500.0f, 4500.0f, 125.0f};

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

extern void* LuaStateRun;

void* h_EndCall(IScriptSystem* scriptSys) // this is the method where we will exeucte lua
{
	if (LuaStateRun)
	{
		lua_c_ExecuteLuaFile(LuaStateRun, "script.lua");
		LuaStateRun = 0;
	}

	return o_EndCall(scriptSys);
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

extern bool b_PacketEditor;

UINT_PTR __fastcall h_Encrypt_Send_Packet(UINT_PTR localUnit, UINT_PTR packetBody)
{
	if (b_PacketEditor)
	{
		peditor.Push((UINT_PTR)packetBody);
		printf("Opcode %04x  -- %p\n", *(WORD*)(packetBody + 8), _ReturnAddress());
	}
	return o_Encrypt_Send(localUnit, packetBody);
}

bool __fastcall h_EncryptPacket(__int64* Buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer)
{
	packetinfo.sUnknown = Buffer;
	packetinfo.sClear = cleartextbuffer;

	if (isEncrypted == 1)
	{
		//peditor.Push((UINT_PTR)key);
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

	if (g_HijackCtrl && g_ShowMenu)
	{
		SetCursor((HCURSOR)LoadImageA(NULL, MAKEINTRESOURCEA(32515), IMAGE_CURSOR, 0, 0, LR_SHARED));
	}

	if (uMsg == WM_KEYUP)
	{
		if (wParam == VK_OEM_3)
		{
			g_ShowMenu = !g_ShowMenu;
		}

		if (wParam == VK_NUMPAD6)
		{
			auto test = Inventory::get_item_master_info(2);
			printf("%s %d %d %d %d %d %d\n", test.Name.c_str(), test.currentStack, test.isConsumable, test.itemId, test.MaxStack, test.skillType, test.levelRequirement);
		}
		if (wParam == VK_NUMPAD7)
		{
			auto test = Inventory::get_all_unidentified_item();

			printf("found %lld consumable.\n", test.size());

			
			for (auto ele : test){
				auto slot = Inventory::find_bag_item_slot_by_itemId(ele);

				if (!slot)
				{
					printf("slot invalid\n");
					continue;
				}

				auto test2 = Inventory::get_item_master_info(slot);

				if (test2.itemId == 0)
				{
					printf("itemid invalid\n");
					continue;
				}

				printf("%s %d\n", test2.Name.data(), test2.slot);
			}

		}
		if (wParam == VK_NUMPAD8)
		{
			printf("%p\n", Skill::get_skill_by_id(11948));

		}

		if (wParam == VK_NUMPAD9)
		{
			Inventory::move_partial_item(7, 2, true);

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

DWORD __stdcall InitializeHooks()
{
	hWnd = FindWindowEx(0, 0, L"ArcheAge", 0);

	if (!findPatterns())
		return 0;

	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + Patterns.Offset_Swapchain);

	dx_swapchain.vmt = ((void**)pSwapChainVtable);

	phookD3D11Present = (f_D3D11PresentHook)dx_swapchain.Hook(8, hookD3D11Present);

	LocateLuaFunctions();

	X2::InitializeX2();


	o_EncryptPacket = (f_EncryptPacket)Patterns.Func_EncryptPacket;
	o_EncryptPacket = (f_EncryptPacket)detours.Hook(o_EncryptPacket, h_EncryptPacket, 14);

	DWORD Func_Offset = *(DWORD*)(Patterns.Func_SendEncryptPacket + 8);

	o_Encrypt_Send = (f_EncryptSendPacket)Patterns.Func_SendEncryptPacket;
	o_Encrypt_Send = (f_EncryptSendPacket)detours.Hook(o_Encrypt_Send, h_Encrypt_Send_Packet, 15);

	DWORD Func_Delta = Patterns.Func_SendEncryptPacket - (UINT_PTR)o_Encrypt_Send;
	*(DWORD*)((UINT_PTR)o_Encrypt_Send + 8) = (Func_Offset + Func_Delta);

	DWORD_PTR* p3DEngineVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->p3DEngine;
	vGetWaterLevel.vmt = (void**)p3DEngineVtable;
	o_GetWaterLevel = (f_GetWaterLevel)vGetWaterLevel.Hook(71, h_GetWaterLevel);

	DWORD_PTR* pScriptSysVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->pScriptSysOne;
	vEndCall.vmt = (void**)pScriptSysVtable;
	o_EndCall = (f_EndCall)vEndCall.Hook(17, h_EndCall);


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