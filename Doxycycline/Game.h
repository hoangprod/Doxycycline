#pragma once

typedef __int64(__fastcall* f_GetNavPath_and_Move)(UINT_PTR* ActorUnit, Vec3 * EndPosition);
typedef UINT_PTR(__fastcall* f_GetClientUnit)(unsigned int UnitId);
typedef char(__fastcall* f_UseSkillWrapper)(__int64 null, unsigned int skillId, __int64 Struct, char null_1, char null_2, char null_3);
typedef float(__fastcall* f_VelocityOfIndex)(int index);
typedef bool(__fastcall* f_isLootable)(__int64 lootClass, unsigned int NetworkId);
typedef char(__fastcall* f_loot_all)(unsigned int null);
typedef void*(__fastcall* f_get_skill_by_id)(uint32_t skillID);
typedef void*(__fastcall* f_get_skill_cooldown)(void* skill_struct, void* cooldownHolderStruct, void* unkBuffer);

typedef BOOL(__fastcall* f_AI_IsCasting)(void* nullParam, int unitID);
typedef void* (__fastcall* f_AI_StopCasting)(void* nullParam, int unitID);
typedef BOOL(__fastcall* f_AI_IsChanneling)(void* nullParam, int unitID);
typedef void* (__fastcall* f_AI_GetGlobalCooldown)(void* nullParam, int unitID); // not sure if this returns a 4 byte or 8 byte value
typedef bool(__fastcall* f_AI_CheckBuff)(void* nullParam, int unitID, uint32_t buffID);

typedef UINT_PTR* (__fastcall* f_GetSlotClass)(void);
typedef UINT_PTR* (__fastcall* f_GetBagClass)(void);
typedef UINT_PTR* (__fastcall* f_GetBankClass)(void);
typedef UINT_PTR* (__fastcall* f_GetItemInformation)(UINT_PTR* StorageClass, uint32_t slot);
typedef UINT_PTR* (__fastcall* f_GetItemInformationEx)(uint32_t ItemId);
typedef UINT_PTR* (__fastcall* f_GetItemInfoExtra)(uint32_t itemInfoEx);
typedef UINT_PTR(__fastcall* f_GetItemIdCount)(UINT_PTR* StorageClass, int itemType, char null, char one, UINT_PTR null_2);
typedef UINT_PTR(__fastcall* f_GetEmptySlotCount)(UINT_PTR* StorageClass);

typedef bool(__fastcall* f_MoveItemToEmptyBankSlot)(uint32_t slot);
typedef bool(__fastcall* f_MoveItemToEmptyCofferSlot)(uint32_t slot);
typedef bool(__fastcall* f_MoveItemToEmptyBagSlot)(uint32_t slot);
typedef bool(__fastcall* f_UseItemById)(uint32_t itemId);
typedef bool(__fastcall* f_GetSkillInfo)(uint32_t skillId, UINT_PTR* LocalUnit, char** name, char** abilityName, int* learnLevel, int* levelStep, bool* show, char** iconPath, float* minRange, float* maxRange, int* manaCost, int* castingTime,
	int* cooldownTime, char ** description, int* nextLearnLevel, int* firstLearnLevel, bool* isHarmful, bool* isHelpful, bool* isMeleeAttack, bool* hasRange, int* upgradeCost, int* skillPoints);

typedef void(__fastcall* f_MoveItemPartial)(UINT_PTR* storageClass, uint32_t Slot, uint32_t Quantity);
typedef void(__fastcall* f_DepositMoney)(int Amount, int AAPointCount);
typedef void(__fastcall* f_WithdrawMoney)(int Amount, int AAPointCount);

typedef UINT_PTR(__fastcall* f_GetUnitStats)(UINT_PTR* UnitClass, uint32_t statType, char null);

class X2
{
public:
	//X2();
	static void InitializeX2();
	static long long W_GetNavPath_and_Move(UINT_PTR* ActorUnit, Vec3* EndPos);
	static UINT_PTR W_GetUnitById(uint32_t UnitId);
	static char W_UseSkillWrapper(UINT_PTR null, uint32_t skillId, UINT_PTR Struct, char null_1, char null_2, char null_3);
	static float W_VelocityOfIndex(int Index);
	static bool W_isLootable(UINT_PTR lootClass, uint32_t NetworkId);
	static char W_loot_all(uint32_t null);

	static bool W_get_skill_info(uint32_t skillId, CSkill * skillInfo);
	static bool W_get_skill_info(uint32_t skillId, char** Name, char** abilityType, int* learnLevel, int* levelStep, bool* show, float* minRange, float* maxRange, int* manaCost, int* castingTime, int* cooldownTime,
		int* nextLearnLevel, int* firstLearnLevel, bool* isHarmful, bool* isHelpful, bool* isMeleeAttack, bool* hasRange, int* upgradeCost, int* skillPoints);
	static ISkill* W_get_skill_by_id(uint32_t skillId);
	static void* W_get_skill_cooldown(void* skill_struct, void* cooldownHolderStruct, void* unkBuffer);

	static bool W_AI_IsCasting(void* nullParam, uint32_t unitId);
	static void* W_AI_StopCasting(void* nullParam, uint32_t unitId);
	static bool W_AI_IsChanneling(void* nullParam, uint32_t unitId);
	static void* W_AI_GetGlobalCooldown(void* nullParam, uint32_t unitId);
	static bool W_AI_CheckBuff(void* nullParam, uint32_t unitId, uint32_t buffId);

	static UINT_PTR* W_GetSlotClass();
	static UINT_PTR* W_GetBagClass();
	static UINT_PTR* W_GetBankClass();

	static UINT_PTR* W_GetItemInformation(UINT_PTR* StorageClass, uint32_t slot);
	static UINT_PTR* W_GetItemInformationEx(uint32_t ItemId);
	static UINT_PTR* W_GetItemInfoExtra(uint32_t itemInfoEx);

	static UINT_PTR W_GetItemIdCount(UINT_PTR* StorageClass, int itemType);
	static UINT_PTR W_GetEmptySlotCount(UINT_PTR* StorageClass);

	static bool W_MoveItemToEmptyBankSlot(uint32_t slot);
	static bool W_MoveItemToEmptyCofferSlot(uint32_t slot);
	static bool W_MoveItemToEmptyBagSlot(uint32_t slot);
	static bool W_UseItemById(uint32_t itemId);

	static void W_MoveItemPartial(UINT_PTR* itemInformation, uint32_t Slot, uint32_t Quantity);
	static void W_DepositMoney(int Amount, int AAPointCount);
	static void W_WithdrawMoney(int Amount, int AAPointCount);

	static UINT_PTR W_GetUnitStats(UINT_PTR* unitClass, uint32_t statType);
};

