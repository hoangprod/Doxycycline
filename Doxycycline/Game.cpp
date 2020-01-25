#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Game.h"
extern Addr Patterns;

X2::X2()
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
