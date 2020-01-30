#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Skills.h"
#include "Game.h"
extern Addr Patterns;

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

void X2::InitializeX2()
{
	o_GetNavPath_and_Move = (f_GetNavPath_and_Move)Patterns.Func_GetSetNavPath;
	o_GetClientUnit = (f_GetClientUnit)Patterns.Func_GetClientUnit;
	o_UseSkillWrapper = (f_UseSkillWrapper)Patterns.Func_CastSkillWrapper;
	o_VelocityOfIndex = (f_VelocityOfIndex)Patterns.Func_GetIndexVelocity;
	o_loot_all = (f_loot_all)Patterns.Func_LootAll;
	o_isLootable = (f_isLootable)Patterns.Func_isLootable;
	o_get_skill_by_id = (f_get_skill_by_id)Patterns.Func_GetSkillByID;
	o_get_skill_cooldown = (f_get_skill_cooldown)Patterns.Func_GetSkillCooldown;

	o_AI_IsCasting = (f_AI_IsCasting)Patterns.Func_AI_IsCasting;
	o_AI_StopCasting = (f_AI_StopCasting)Patterns.Func_AI_StopCasting;
	o_AI_IsChanneling = (f_AI_IsChanneling)Patterns.Func_AI_IsChanneling;
	o_AI_GetGlobalCooldown = (f_AI_GetGlobalCooldown)Patterns.Func_AI_GetGlobalCooldown;
	o_AI_CheckBuff = (f_AI_CheckBuff)Patterns.Func_AI_CheckBuff;
}

long long X2::W_GetNavPath_and_Move(UINT_PTR* ActorUnit, Vec3* EndPos)
{
	return o_GetNavPath_and_Move(ActorUnit, EndPos);
}

UINT_PTR X2::W_GetClientUnit(uint32_t UnitId)
{
	return o_GetClientUnit(UnitId);
}

char X2::W_UseSkillWrapper(UINT_PTR null, uint32_t skillId, UINT_PTR Struct, char null_1, char null_2, char null_3)
{
	return o_UseSkillWrapper(null, skillId, Struct, null_1, null_2, null_3);
}

float X2::W_VelocityOfIndex(int Index)
{
	return o_VelocityOfIndex(Index);
}

bool X2::W_isLootable(UINT_PTR lootClass, uint32_t NetworkId)
{
	return o_isLootable(lootClass, NetworkId);
}

char X2::W_loot_all(uint32_t null)
{
	return o_loot_all(null);
}

ISkill* X2::W_get_skill_by_id(uint32_t skillId)
{
	return (ISkill*)o_get_skill_by_id(skillId);
}

void* X2::W_get_skill_cooldown(void* skill_struct, void* cooldownHolderStruct, void* unkBuffer)
{
	return o_get_skill_cooldown(skill_struct, cooldownHolderStruct, unkBuffer);
}

bool X2::W_AI_IsCasting(void* nullParam, uint32_t unitId)
{
	return o_AI_IsCasting(nullParam, unitId);
}

void* X2::W_AI_StopCasting(void* nullParam, uint32_t unitId)
{
	return o_AI_StopCasting(nullParam, unitId);
}

bool X2::W_AI_IsChanneling(void* nullParam, uint32_t unitId)
{
	return o_AI_IsChanneling(nullParam, unitId);
}

void* X2::W_AI_GetGlobalCooldown(void* nullParam, uint32_t unitId)
{
	return o_AI_GetGlobalCooldown(nullParam, unitId);
}

bool X2::W_AI_CheckBuff(void* nullParam, uint32_t unitId, uint32_t buffId)
{
	return o_AI_CheckBuff(nullParam, unitId, buffId);
}

