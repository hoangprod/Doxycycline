#include <Windows.h>
#include <tchar.h>
#include <TlHelp32.h>
#include <strsafe.h>
#include <vector>
#include "Scan.h"
#include "Patterns.h"
#include "Helper.h"

#define ReCa reinterpret_cast
#ifdef UNICODE
#undef Module32First
#undef Module32Next
#undef MODULEENTRY32
#endif

BYTE* GetProcAddressA(HINSTANCE hDll, const char* szFunc);

typedef struct _UNICODE_STRING {
	USHORT Length;
	USHORT MaximumLength;
	PWSTR  Buffer;
} UNICODE_STRING, * PUNICODE_STRING;

typedef struct _LDR_DATA_TABLE_ENTRY
{
	LIST_ENTRY InLoadOrderLinks;
	LIST_ENTRY InMemoryOrderLinks;
	LIST_ENTRY InInitializationOrderLinks;
	PVOID DllBase;
	PVOID EntryPoint;
	ULONG SizeOfImage;
	UNICODE_STRING FullDllName;
	UNICODE_STRING BaseDllName;
	ULONG Flags;
	WORD LoadCount;
	WORD TlsIndex;
	union
	{
		LIST_ENTRY HashLinks;
		struct
		{
			PVOID SectionPointer;
			ULONG CheckSum;
		};
	};
	union
	{
		ULONG TimeDateStamp;
		PVOID LoadedImports;
	};
	_ACTIVATION_CONTEXT* EntryPointActivationContext;
	PVOID PatchInformation;
	LIST_ENTRY ForwarderLinks;
	LIST_ENTRY ServiceTagLinks;
	LIST_ENTRY StaticLinks;
} LDR_DATA_TABLE_ENTRY, * PLDR_DATA_TABLE_ENTRY;

void* HdnGetModuleBase(const char* moduleName)
{
	wchar_t wModuleName[100];

	MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, moduleName, -1, wModuleName, 100);

#if defined( _WIN64 )  
#define PEBOffset 0x60  
#define LdrOffset 0x18  
#define ListOffset 0x10  
	unsigned long long pPeb = __readgsqword(PEBOffset);
#elif defined( _WIN32 )  
#define PEBOffset 0x30  
#define LdrOffset 0x0C  
#define ListOffset 0x0C  
	unsigned long pPeb = __readfsdword(PEBOffset);
#endif       
	pPeb = *reinterpret_cast<decltype(pPeb)*>(pPeb + LdrOffset);
	PLDR_DATA_TABLE_ENTRY pModuleList = *reinterpret_cast<PLDR_DATA_TABLE_ENTRY*>(pPeb + ListOffset);
	while (pModuleList->DllBase)
	{
		if (!wcscmp(pModuleList->BaseDllName.Buffer, wModuleName))
			return pModuleList->DllBase;
		pModuleList = reinterpret_cast<PLDR_DATA_TABLE_ENTRY>(pModuleList->InLoadOrderLinks.Flink);
	}
	return nullptr;
}


typedef HMODULE(WINAPI* pLoadLibA)(IN LPCSTR);


HMODULE cLoadLibA(LPCSTR lpLibName)
{
	typedef HMODULE(WINAPI* pLoadLibA)(IN LPCSTR);

	pLoadLibA pLoadLibraryA = nullptr;

	if (!pLoadLibraryA)
	{
		constexpr const char NtApi[] = { 'L', 'o', 'a', 'd', 'L', 'i', 'b', 'r', 'a', 'r', 'y','A','\0' };

		constexpr const char ModuleN[] = { 'K', 'E', 'R', 'N', 'E', 'L', 'B', 'A', 'S', 'E','.', 'd', 'l', 'l', '\0' };

		pLoadLibraryA = static_cast<pLoadLibA>(GetImportB(ModuleN, NtApi));
	}

	return pLoadLibraryA(lpLibName);
}


void* GetImportB(const char* szDll, const char* szFunc)
{
	HINSTANCE hDll = (HINSTANCE)HdnGetModuleBase(szDll);

	if (!hDll)
	{
		hDll = cLoadLibA(szDll);

		if (!hDll)
		{
			return 0;
		}
	}
	else {
	}

	BYTE* pFunc = GetProcAddressA(hDll, szFunc);
	if (!pFunc)
		return 0;

	return pFunc;
}


HINSTANCE GetModuleHandleExA(HANDLE hProc, const char* szDll)
{
	MODULEENTRY32 ME32{ 0 };
	ME32.dwSize = sizeof(ME32);

	HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetProcessId(hProc));
	if (hSnap == INVALID_HANDLE_VALUE)
	{
		while (GetLastError() == ERROR_BAD_LENGTH)
		{
			hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetProcessId(hProc));

			if (hSnap != INVALID_HANDLE_VALUE)
				break;
		}
	}

	BOOL bRet = Module32First(hSnap, &ME32);
	while (bRet)
	{
		if (!_stricmp(ME32.szModule, szDll))
			break;
		bRet = Module32Next(hSnap, &ME32);
	}
	CloseHandle(hSnap);

	if (!bRet)
		return NULL;

	return ME32.hModule;
}

BYTE* GetProcAddressA(HINSTANCE hDll, const char* szFunc)
{
	if (!hDll)
		return nullptr;

	BYTE* pBase = reinterpret_cast<BYTE*>(hDll);
	auto* pNT = reinterpret_cast<IMAGE_NT_HEADERS*>(pBase + reinterpret_cast<IMAGE_DOS_HEADER*>(pBase)->e_lfanew);
	auto* pDirectory = &pNT->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];
	auto* pExportDir = reinterpret_cast<IMAGE_EXPORT_DIRECTORY*>(pBase + pDirectory->VirtualAddress);
	auto ExportSize = pDirectory->Size;
	DWORD DirRVA = pDirectory->VirtualAddress;

	if (!ExportSize)
		return nullptr;

	if (reinterpret_cast<UINT_PTR>(szFunc) <= MAXWORD)
	{
		WORD Base = LOWORD(pExportDir->Base - 1);
		WORD Ordinal = LOWORD(szFunc) - Base;
		DWORD FuncRVA = reinterpret_cast<DWORD*>(pBase + pExportDir->AddressOfFunctions)[Ordinal];

		if (FuncRVA >= DirRVA && FuncRVA < DirRVA + ExportSize)
		{
			char pFullExport[MAX_PATH]{ 0 };
			auto Len = strlen(reinterpret_cast<char*>(pBase + FuncRVA));
			if (!Len)
				return nullptr;

			memcpy(pFullExport, reinterpret_cast<char*>(pBase + FuncRVA), Len);
			char* pFuncName = strchr(pFullExport, '.');
			*pFuncName++ = '\0';
			if (*pFuncName == '#')
				pFuncName = reinterpret_cast<char*>(LOWORD(atoi(++pFuncName)));

			HINSTANCE hLib = cLoadLibA(pFullExport);
			if (hLib == reinterpret_cast<HINSTANCE>(hDll) && !_stricmp(pFuncName, szFunc))
			{
				return nullptr;
			}

			return GetProcAddressA(hLib, pFuncName);
		}
	}

	DWORD max = pExportDir->NumberOfNames - 1;
	DWORD min = 0;
	WORD Ordinal = 0;

	while (min <= max)
	{
		DWORD mid = (min + max) >> 1;

		DWORD CurrNameRVA = reinterpret_cast<DWORD*>(pBase + pExportDir->AddressOfNames)[mid];
		char* szName = reinterpret_cast<char*>(pBase + CurrNameRVA);

		int cmp = strcmp(szName, szFunc);
		if (cmp < 0)
			min = mid + 1;
		else if (cmp > 0)
			max = mid - 1;
		else
		{
			Ordinal = reinterpret_cast<WORD*>(pBase + pExportDir->AddressOfNameOrdinals)[mid];
			break;
		}
	}

	if (!Ordinal)
		return nullptr;

	DWORD FuncRVA = reinterpret_cast<DWORD*>(pBase + pExportDir->AddressOfFunctions)[Ordinal];

	if (FuncRVA >= DirRVA && FuncRVA < DirRVA + ExportSize)
	{
		char pFullExport[MAX_PATH]{ 0 };
		auto Len = strlen(reinterpret_cast<char*>(pBase + FuncRVA));
		if (!Len)
			return nullptr;

		memcpy(pFullExport, reinterpret_cast<char*>(pBase + FuncRVA), Len);
		char* pFuncName = strchr(pFullExport, '.');
		*pFuncName++ = '\0';
		if (*pFuncName == '#')
			pFuncName = reinterpret_cast<char*>(LOWORD(atoi(++pFuncName)));

		HINSTANCE hLib = cLoadLibA(pFullExport);
		if (hLib == reinterpret_cast<HINSTANCE>(hDll) && !_stricmp(pFuncName, szFunc))
		{
			return nullptr;
		}

		return GetProcAddressA(hLib, pFuncName);
	}

	return pBase + FuncRVA;
}


void* DetourFunction64(void* pSource, void* pDestination, int dwLen)
{
	DWORD MinLen = 14;

	if (dwLen < MinLen) return NULL;

	BYTE stub[] = {
	0xFF, 0x25, 0x00, 0x00, 0x00, 0x00, // jmp qword ptr [$+6]
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 // ptr
	};

	void* pTrampoline = VirtualAlloc(0, dwLen + sizeof(stub), MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);

	DWORD dwOld = 0;
	VirtualProtect(pSource, dwLen, PAGE_EXECUTE_READWRITE, &dwOld);

	DWORD64 retto = (DWORD64)pSource + dwLen;

	memcpy(stub + 6, &retto, 8);
	memcpy((void*)((DWORD_PTR)pTrampoline), pSource, dwLen);
	memcpy((void*)((DWORD_PTR)pTrampoline + dwLen), stub, sizeof(stub));

	// orig
	memcpy(stub + 6, &pDestination, 8);
	memcpy(pSource, stub, sizeof(stub));

	for (int i = MinLen; i < dwLen; i++)
	{
		*(BYTE*)((DWORD_PTR)pSource + i) = 0x90;
	}

	VirtualProtect(pSource, dwLen, dwOld, &dwOld);
	return (void*)((DWORD_PTR)pTrampoline);
}

char* Scan_Offsets(char* pBase, UINT_PTR RegionSize, const char* szPattern, const char* szMask, uintptr_t szOffset, size_t szSize)
{
	char* result = 0;
	char* initResult = PatternScan(pBase, RegionSize, szPattern, szMask);

	if ((size_t)initResult)
	{
		memcpy(&result, initResult + szOffset, szSize);
		if (result)
			return result;
	}
	return nullptr;
}

char* ptr_offset_Scanner(char* pBase, UINT_PTR RegionSize, const char* szPattern, uintptr_t i_offset,
	uintptr_t i_length, uintptr_t instruction_before_offset, const char* szMask)
{
	char* initial_addr = PatternScan(pBase, RegionSize, szPattern, szMask);
	if (!initial_addr)
	{
		return nullptr;
	}

	char* offset_read = nullptr;
	char* second_addr = initial_addr + i_offset + instruction_before_offset;

	memcpy(&offset_read, second_addr, i_length - instruction_before_offset);

	offset_read = i_length + initial_addr + i_offset + (int)offset_read;


	if (offset_read)
		return offset_read;

	return nullptr;
}

Detour64::Detour64()
{
	// Empty
}

void* Detour64::Hook(void* pSource, void* pDestination, int dwLen)
{

	void * trampoline = DetourFunction64(pSource, pDestination, dwLen);

	Detour64::detour saveDetour = { pSource, (char*)trampoline, dwLen };

	hooked_funcs.push_back(saveDetour);

	return trampoline;
}

bool Detour64::Unhook(void* pTrampoline)
{
	for (func_iterator = hooked_funcs.begin(); func_iterator != hooked_funcs.end(); func_iterator++)
	{
		Detour64::detour curHook = *func_iterator;

		if (pTrampoline == curHook.origBytes)
		{
			DWORD dwOld = 0;
			VirtualProtect(curHook.origAddr, 1, PAGE_EXECUTE_READWRITE, &dwOld);
			memcpy(curHook.origAddr, curHook.origBytes, curHook.orgByteCount);
			VirtualProtect(curHook.origAddr, 1, dwOld, &dwOld);
			
			if (*(char*)curHook.origAddr == *curHook.origBytes)
			{
				VirtualFree(curHook.origBytes, 0, MEM_RELEASE);
				hooked_funcs.erase(func_iterator);
				return true;
			}
			else
			{
				printf("Unhook failed at %p\n", curHook.origAddr);
				return false;
			}
		}

	}

	return false;
}

extern Addr Patterns;

bool Detour64::Clearhook()
{
	for (func_iterator = hooked_funcs.begin(); func_iterator != hooked_funcs.end(); func_iterator++)
	{
		detour curHook = *func_iterator;

		DWORD dwOld = 0;
		VirtualProtect(curHook.origAddr, 1, PAGE_EXECUTE_READWRITE, &dwOld);
		memcpy(curHook.origAddr, curHook.origBytes, curHook.orgByteCount);

		if ((UINT_PTR)curHook.origAddr == Patterns.Func_SendEncryptPacket)
		{
			DWORD oldBytes = *(DWORD*)(Patterns.Func_SendEncryptPacket + 8);
			UINT_PTR Delta = (UINT_PTR)curHook.origAddr - (UINT_PTR)curHook.origBytes;
			*(DWORD*)(Patterns.Func_SendEncryptPacket + 8) = oldBytes - Delta;
		}


		VirtualProtect(curHook.origAddr, 1, dwOld, &dwOld);

		if (*(char*)curHook.origAddr == *curHook.origBytes)
		{
			VirtualFree(curHook.origBytes, 0, MEM_RELEASE);
		}
		else
		{
			printf("Unhook failed at %p\n", curHook.origAddr);
			return false;
		}
	}
	hooked_funcs.clear();
	return true;
}
