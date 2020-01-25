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
	X2();

	f_GetNavPath_and_Move o_GetNavPath_and_Move;
	f_GetClientUnit o_GetClientUnit;
	f_UseSkillWrapper o_UseSkillWrapper;
	f_VelocityOfIndex o_VelocityOfIndex;
	f_isLootable o_isLootable;
	f_loot_all o_loot_all;
	f_get_skill_by_id o_get_skill_by_id;
	f_get_skill_cooldown o_get_skill_cooldown;

	f_AI_IsCasting o_AI_IsCasting;
	f_AI_StopCasting o_AI_StopCasting;
	f_AI_IsChanneling o_AI_IsChanneling;
	f_AI_GetGlobalCooldown o_AI_GetGlobalCooldown;
	f_AI_CheckBuff o_AI_CheckBuff;
};

