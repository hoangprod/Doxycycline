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
	UINT_PTR Addr_LootClass;
	UINT_PTR Addr_GameStage;
	UINT_PTR Addr_TransitionStage;

	DWORD Offset_LocalUnit;
	DWORD Offset_ActorUnitModel;
	DWORD Offset_Swapchain;
	DWORD Offset_UserStats;
	DWORD Offset_SpeedStat;
	DWORD Offset_CurrentTargetId;
	DWORD Offset_isInCombat;
	DWORD Offset_IsUnitInCombat;
	DWORD Offset_isDead;

	UINT_PTR Func_EncryptPacket;
	UINT_PTR Func_SendEncryptPacket;
	UINT_PTR Func_UpdateSwimCaller;
	UINT_PTR Func_GetSetNavPath;
	UINT_PTR Func_GetClientUnit;

	UINT_PTR Func_GetIndexVelocity;
	UINT_PTR Func_LootAll;
	UINT_PTR Func_isLootable;

	UINT_PTR Func_GetSkillByID;
	UINT_PTR Func_GetSkillCooldown;
	UINT_PTR Func_CastSkillWrapper;

	UINT_PTR Func_GetSlotClass;
	UINT_PTR Func_GetBagClass;
	UINT_PTR Func_GetBankClass;
	UINT_PTR Func_GetEmptySlotCount;
	UINT_PTR Func_GetItemIdCount;
	UINT_PTR Func_MoveItemToEmptyBankSlot;
	UINT_PTR Func_MoveItemToEmptyCofferSlot;
	UINT_PTR Func_MoveItemToEmptyBagSlot;
	UINT_PTR Func_DepositMoney;
	UINT_PTR Func_WithdrawMoney;
	UINT_PTR Func_UseItemById;
	UINT_PTR Func_GetItemInformation;
	UINT_PTR Func_GetItemInformationEx;
	UINT_PTR Func_PickupItemPartial;

	UINT_PTR Func_AI_IsCasting;
	UINT_PTR Func_AI_StopCasting;
	UINT_PTR Func_AI_IsChanneling;
	UINT_PTR Func_AI_GetGlobalCooldown;
	UINT_PTR Func_AI_CheckBuff;
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