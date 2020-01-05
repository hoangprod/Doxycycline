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

typedef float(__fastcall* f_GetWaterLevel)(void* cry3DEngine, void* referencePOS);
typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);

typedef HRESULT(__stdcall* f_D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);

extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
extern packetCrypto packetinfo;

ID3D11Device* pDevice = NULL;
ID3D11DeviceContext* pContext = NULL;

static IDXGISwapChain* pSwapChain = NULL;

static WNDPROC OriginalWndProcHandler = nullptr;

f_D3D11PresentHook phookD3D11Present = NULL;
ID3D11RenderTargetView* mainRenderTargetView;

HWND window = nullptr;
HWND hWnd = nullptr;

VMTHook dx_swapchain;
VMTHook vGetWaterLevel;

bool g_ShowMenu = false;

f_EncryptPacket o_EncryptPacket = NULL;
f_GetWaterLevel o_GetWaterLevel = NULL;

Detour64 detours;

HRESULT GetDeviceAndCtxFromSwapchain(IDXGISwapChain* pSwapChain, ID3D11Device** ppDevice, ID3D11DeviceContext** ppContext)
{
	HRESULT ret = pSwapChain->GetDevice(__uuidof(ID3D11Device), (PVOID*)ppDevice);

	if (SUCCEEDED(ret))
		(*ppDevice)->GetImmediateContext(ppContext);

	return ret;
}


float __fastcall h_GetWaterLevel(void* cry3DEngine, void* referencePOS)
{
	static char* pUpdateSwimCaller = NULL;

	if (!pUpdateSwimCaller) {
		pUpdateSwimCaller = PatternScan((char*)HdnGetModuleBase("x2game.dll"), 0x500000, "\x0f\x28\xc8\xf3\x0f\x5c\xCC\xCC\x00\x00\x00\x41\x0f\x2f\xcc", "xxxxxx??xxxxxxx");
	}

	if (bFlyHack)
	{
		void* address = _ReturnAddress();
		if (address == (void*)pUpdateSwimCaller)
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


DWORD __stdcall InitializeHooks()
{
	hWnd = FindWindowEx(0, 0, L"ArcheAge", 0);

	char* offset_Swapchain = Scan_Offsets((char*)HdnGetModuleBase("CryRenderD3D10.dll"), 0x200000, "\x48\x8b\x8b\xCC\xCC\xCC\x00\x48\x8b\x01\xff\x50\x40\x8b\xf8\x3d\x21\x00\x7a\x88", "xxx???xxxxxxxxxxxxxx", 3, 4);

	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + offset_Swapchain); // offset_Swapchain =  0x159e0

	dx_swapchain.vmt = ((void**)pSwapChainVtable);

	phookD3D11Present = (f_D3D11PresentHook)dx_swapchain.Hook(8, hookD3D11Present);

	char* pEncryptPacket = PatternScan((char*)HdnGetModuleBase("CryNetwork.dll"), 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	o_EncryptPacket = (f_EncryptPacket)pEncryptPacket;

	o_EncryptPacket = (f_EncryptPacket)detours.Hook(o_EncryptPacket, h_EncryptPacket, 14);

	DWORD_PTR* p3DEngineVtable = *(DWORD_PTR**)SSystemGlobalEnvironment::GetInstance()->p3DEngine;

	vGetWaterLevel.vmt = (void**)p3DEngineVtable;

	o_GetWaterLevel = (f_GetWaterLevel)vGetWaterLevel.Hook(71, h_GetWaterLevel);
	

	return NULL;
}

bool __stdcall Unload()
{
	if (detours.Unhook(o_EncryptPacket))
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