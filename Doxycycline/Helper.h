#pragma once

struct packetCrypto
{
	__int64* sUnknown;
	int* sClear;
};

HINSTANCE GetModuleHandleExA(HANDLE hProc, const char* szDll);

void* GetImportB(const char* szDll, const char* szFunc);
void* HdnGetModuleBase(const char* moduleName);
void* DetourFunction64(void* pSource, void* pDestination, int dwLen);

char* ptr_offset_Scanner(char* pBase, UINT_PTR RegionSize, const char* szPattern, uintptr_t i_offset,
	uintptr_t i_length, uintptr_t instruction_before_offset, const char* szMask);

char* Scan_Offsets(char* pBase, UINT_PTR RegionSize, const char* szPattern, const char* szMask, uintptr_t szOffset, size_t szSize);

struct Addr {
	BYTE* Addr_isAutoPathing;
	FLOAT* Addr_SpeedModifier;
	UINT_PTR Addr_gEnv;
	UINT_PTR Addr_UnitClass;

	DWORD Offset_LocalUnit;
	DWORD Offset_ActorUnitModel;
	DWORD Offset_Swapchain;
	DWORD Offset_UserStats;
	DWORD Offset_SpeedStat;
	DWORD Offset_CurrentTargetId;
	DWORD Offset_isInCombat;

	UINT_PTR Func_EncryptPacket;
	UINT_PTR Func_UpdateSwimCaller;
	UINT_PTR Func_GetSetNavPath;
	UINT_PTR Func_GetClientUnit;
	UINT_PTR Func_CastSkillWrapper;
	UINT_PTR Func_GetIndexVelocity;

	UINT_PTR Func_AI_IsCasting;
	UINT_PTR Func_AI_StopCasting;
	UINT_PTR Func_AI_IsChanneling;
	UINT_PTR Func_AI_GetGlobalCooldown;
};

class Detour64
{
public:

	struct detour {
		void* origAddr;
		char* origBytes;
		int orgByteCount;
	};

	Detour64();

	void* Hook(void* pSource, void* pDestination, int dwLen);
	
	bool Unhook(void* pSource);
	bool Clearhook();

private:
	std::vector<detour>::iterator func_iterator; // Iterator so we can iterate the map below
	std::vector<detour> hooked_funcs; // std::map which holds the original function's address and original function's byte and its count
};