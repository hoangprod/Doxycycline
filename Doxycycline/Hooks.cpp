#include "pch.h"
#include "Hooks.h"
#include "Menu.h"
#include "vmt.h"
#include "Scan.h"
#include "Helper.h"
#include "GameClasses.h"

typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);
typedef HRESULT(__stdcall* D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);

extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
extern packetCrypto packetinfo;

ID3D11Device* pDevice = NULL;
ID3D11DeviceContext* pContext = NULL;

static IDXGISwapChain* pSwapChain = NULL;

static WNDPROC OriginalWndProcHandler = nullptr;

D3D11PresentHook phookD3D11Present = NULL;
ID3D11RenderTargetView* mainRenderTargetView;

HWND window = nullptr;
HWND hWnd = nullptr;

VMTHook dx_swapchain;

bool g_ShowMenu = false;

f_EncryptPacket o_EncryptPacket = NULL;

Detour64 detours;

HRESULT GetDeviceAndCtxFromSwapchain(IDXGISwapChain* pSwapChain, ID3D11Device** ppDevice, ID3D11DeviceContext** ppContext)
{
	HRESULT ret = pSwapChain->GetDevice(__uuidof(ID3D11Device), (PVOID*)ppDevice);

	if (SUCCEEDED(ret))
		(*ppDevice)->GetImmediateContext(ppContext);

	return ret;
}

bool __fastcall h_EncryptPacket(__int64* Buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer)
{
	packetinfo.sUnknown = Buffer;
	packetinfo.sClear = cleartextbuffer;

	if (isEncrypted == 1)
	{
		printf("woah");
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

	DWORD_PTR* p_Swapchain = (DWORD_PTR*)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + 0x159E0); // Pattern scan 0x159e0
	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)p_Swapchain;
	dx_swapchain.vmt = ((void**)pSwapChainVtable);

	phookD3D11Present = (D3D11PresentHook)dx_swapchain.Hook(8, hookD3D11Present);

	// Scan for EncryptFunction **** Switch to custom GetModuleHandle and better signature.
	char* pEncryptPacket = PatternScan((char*)HdnGetModuleBase("CryNetwork.dll"), 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	o_EncryptPacket = (f_EncryptPacket)pEncryptPacket;

	o_EncryptPacket = (f_EncryptPacket)detours.Hook(o_EncryptPacket, h_EncryptPacket, 14);

	return NULL;
}

bool __stdcall Unload()
{
	if (detours.Unhook(o_EncryptPacket))
	{
		dx_swapchain.ClearHooks();
		SetWindowLongPtr(window, GWLP_WNDPROC, (LONG_PTR)OriginalWndProcHandler);
		FreeLibrary(h_Module);
		return true;
	}

	printf("Failed to unhook oencrypt\n");

	return false;
}