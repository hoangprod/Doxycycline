#include "pch.h"
#include "Hooks.h"
#include "Menu.h"
#include "vmt.h"
#include "Scan.h"
#include "GameClasses.h"
typedef bool(__fastcall* f_EncryptPacket)(__int64* a1, unsigned __int8 a2, __int64 packet, int* a3);
typedef HRESULT(__stdcall* D3D11PresentHook) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);

extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

ID3D11Device* pDevice = NULL;
ID3D11DeviceContext* pContext = NULL;

static IDXGISwapChain* pSwapChain = NULL;

static WNDPROC OriginalWndProcHandler = nullptr;

D3D11PresentHook phookD3D11Present = NULL;
ID3D11RenderTargetView* mainRenderTargetView;

HWND window = nullptr;
HWND hWnd = nullptr;

bool firstTime = true;
bool g_ShowMenu = false;

f_EncryptPacket o_EncryptPacket = NULL;

VMTHook vmt_dx_swapchain((void*)0);

int* sClear = NULL;
__int64 fakeKey = 0;
__int64* sUnknown = 0;

bool __fastcall h_EncryptPacket(__int64* Buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer)
{
	sUnknown = Buffer;
	sClear = cleartextbuffer;

	if (isEncrypted == 1)
	{
		peditor.Push((UINT_PTR)key);
	}

	return o_EncryptPacket(Buffer, isEncrypted, key, cleartextbuffer);
}

HRESULT GetDeviceAndCtxFromSwapchain(IDXGISwapChain* pSwapChain, ID3D11Device** ppDevice, ID3D11DeviceContext** ppContext)
{
	HRESULT ret = pSwapChain->GetDevice(__uuidof(ID3D11Device), (PVOID*)ppDevice);

	if (SUCCEEDED(ret))
		(*ppDevice)->GetImmediateContext(ppContext);

	return ret;
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

BOOL hook_function(PVOID& t1, PBYTE t2, const char* s = NULL)
{
	DetourTransactionBegin();
	DetourUpdateThread(GetCurrentThread());
	DetourAttach(&t1, t2);
	if (DetourTransactionCommit() != NO_ERROR) {
		printf("[Hook] - Failed to hook %s.\n", s);
		return false;
	}
	else {
		printf("[Hook] - Successfully hooked %s.\n", s);
		return true;
	}
}

DWORD __stdcall InitializeHooks()
{
	hWnd = FindWindowEx(0, 0, L"ArcheAge", 0);

	DWORD_PTR* p_Swapchain = (DWORD_PTR*)((DWORD_PTR)SSystemGlobalEnvironment::GetInstance()->pRenderer + 0x159E0);
	DWORD_PTR* pSwapChainVtable = **(DWORD_PTR***)p_Swapchain;
	VMTHook dx_swapchain((void*)pSwapChainVtable);
	vmt_dx_swapchain = dx_swapchain;
	phookD3D11Present = (D3D11PresentHook)vmt_dx_swapchain.Hook(8, hookD3D11Present);

	// Scan for EncryptFunction **** Switch to custom GetModuleHandle and better signature.
	char* pEncryptPacket = PatternScan((char*)GetModuleHandleA("crynetwork.dll"), 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	o_EncryptPacket = (f_EncryptPacket)pEncryptPacket;

	hook_function((PVOID&)o_EncryptPacket, (PBYTE)h_EncryptPacket, "EncryptPacket");

	return NULL;
}

DWORD __stdcall RemoveHooks()
{
	vmt_dx_swapchain.ClearHooks();
}