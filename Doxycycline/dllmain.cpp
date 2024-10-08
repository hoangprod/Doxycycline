#include "pch.h"
#include "Hooks.h"



PVOID WINAPI Initialize()
{
	AllocConsole();
	FILE* fp;
	freopen_s(&fp, "CONOUT$", "w", stdout);

	InitializeHooks();

	return 0;
}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
		h_Module = hModule;
		Initialize();
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:	
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

