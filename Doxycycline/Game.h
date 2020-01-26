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

class X2
{
public:
	//X2();
	static void InitializeX2();
	static long long W_GetNavPath_and_Move(UINT_PTR* ActorUnit, Vec3* EndPos);
	static UINT_PTR W_GetClientUnit(uint32_t UnitId);
	static char W_UseSkillWrapper(UINT_PTR null, uint32_t skillId, UINT_PTR Struct, char null_1, char null_2, char null_3);
	static float W_VelocityOfIndex(int Index);
	static bool W_isLootable(UINT_PTR lootClass, uint32_t NetworkId);
	static char W_loot_all(uint32_t null);
	static ISkill* W_get_skill_by_id(uint32_t skillId);
	static void* W_get_skill_cooldown(void* skill_struct, void* cooldownHolderStruct, void* unkBuffer);

	static bool W_AI_IsCasting(void* nullParam, uint32_t unitId);
	static void* W_AI_StopCasting(void* nullParam, uint32_t unitId);
	static bool W_AI_IsChanneling(void* nullParam, uint32_t unitId);
	static void* W_AI_GetGlobalCooldown(void* nullParam, uint32_t unitId);
	static bool W_AI_CheckBuff(void* nullParam, uint32_t unitId, uint32_t buffId);
};

