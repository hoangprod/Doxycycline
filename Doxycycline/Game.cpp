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

f_GetSlotClass o_GetSlotClass;
f_GetBagClass o_GetBagClass;
f_GetBankClass o_GetBankClass;
f_GetItemInformation o_GetItemInformation;
f_GetItemInformationEx o_GetItemInformationEx;
f_GetItemIdCount o_GetItemIdCount;
f_GetEmptySlotCount o_GetEmptySlotCount;

f_MoveItemToEmptyBankSlot o_MoveItemToEmptyBankSlot;
f_MoveItemToEmptyCofferSlot o_MoveItemToEmptyCofferSlot;
f_MoveItemToEmptyBagSlot o_MoveItemToEmptyBagSlot;
f_UseItemById o_UseItemById;

f_DepositMoney o_DepositMoney;
f_WithdrawMoney o_WithdrawMoney;


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

	o_GetSlotClass = (f_GetSlotClass)Patterns.Func_GetSlotClass;
	o_GetBagClass = (f_GetBagClass)Patterns.Func_GetBagClass;
	o_GetBankClass = (f_GetBankClass)Patterns.Func_GetBankClass;
	o_GetItemInformation = (f_GetItemInformation)Patterns.Func_GetItemInformation;
	o_GetItemInformationEx = (f_GetItemInformationEx)Patterns.Func_GetItemInformationEx;
	o_GetItemIdCount = (f_GetItemIdCount)Patterns.Func_GetItemIdCount;
	o_GetEmptySlotCount = (f_GetEmptySlotCount)Patterns.Func_GetEmptySlotCount;

	o_MoveItemToEmptyBankSlot = (f_MoveItemToEmptyBankSlot)Patterns.Func_MoveItemToEmptyBankSlot;
	o_MoveItemToEmptyCofferSlot = (f_MoveItemToEmptyCofferSlot)Patterns.Func_MoveItemToEmptyCofferSlot;
	o_MoveItemToEmptyBagSlot = (f_MoveItemToEmptyBagSlot)Patterns.Func_MoveItemToEmptyBagSlot;
	o_UseItemById = (f_UseItemById)Patterns.Func_UseItemById;
	o_DepositMoney = (f_DepositMoney)Patterns.Func_DepositMoney;
	o_WithdrawMoney = (f_WithdrawMoney)Patterns.Func_WithdrawMoney;
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

UINT_PTR* X2::W_GetSlotClass()
{
	return o_GetSlotClass();
}

UINT_PTR* X2::W_GetBagClass()
{
	return o_GetBagClass();
}

UINT_PTR* X2::W_GetBankClass()
{
	return o_GetBankClass();
}

UINT_PTR* X2::W_GetItemInformation(UINT_PTR* StorageClass, uint32_t slot)
{
	return o_GetItemInformation(StorageClass, slot);
}

UINT_PTR* X2::W_GetItemInformationEx(uint32_t ItemId)
{
	return o_GetItemInformationEx(ItemId);
}

UINT_PTR X2::W_GetItemIdCount(UINT_PTR* StorageClass, int itemType)
{
	return o_GetItemIdCount(StorageClass, itemType, 0, 1, 0);
}

UINT_PTR X2::W_GetEmptySlotCount(UINT_PTR* StorageClass)
{
	return o_GetEmptySlotCount(StorageClass);
}

bool X2::W_MoveItemToEmptyBankSlot(uint32_t slot)
{
	return o_MoveItemToEmptyBankSlot(slot);
}

bool X2::W_MoveItemToEmptyCofferSlot(uint32_t slot)
{
	return o_MoveItemToEmptyCofferSlot(slot);
}

bool X2::W_MoveItemToEmptyBagSlot(uint32_t slot)
{
	return o_MoveItemToEmptyBagSlot(slot);
}

bool X2::W_UseItemById(uint32_t itemId)
{
	return o_UseItemById(itemId);
}

void X2::W_DepositMoney(int Amount, int AAPointCount)
{
	return o_DepositMoney(Amount, AAPointCount);
}

void X2::W_WithdrawMoney(int Amount, int AAPointCount)
{
	return o_WithdrawMoney(Amount, AAPointCount);
}
