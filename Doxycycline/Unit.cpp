#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "Combat.h"
#include "Helper.h"
#include "Unit.h"

extern Addr Patterns;

uint32_t Unit::GetLocalPlayerUnitId()
{
	auto LocalPlayerUnit = GetLocalPlayerUnitClass();

	if (!LocalPlayerUnit)
		return 0;

	uint32_t localUnitId = *(uint32_t*)(LocalPlayerUnit + 1);

	return localUnitId;
}


UINT_PTR* Unit::GetLocalPlayerUnitClass()
{
	return *(UINT_PTR**)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);
}

UINT_PTR* Unit::GetUnitById(uint32_t unitId)
{
	UINT_PTR* Unit = (UINT_PTR*)X2::W_GetUnitById(unitId);

	if (!Unit)
		return 0;

	return Unit;
}

uint32_t Unit::GetUnitMana(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);

	if (!unit)
		return 0;

	uint32_t mana = *(uint32_t*)((UINT_PTR)unit + Patterns.Offset_Mana) / 100;

	return mana;
}

uint32_t Unit::GetUnitMaxMana(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);
	
	if (!unit)
		return 0;

	return X2::W_GetUnitStats(unit, stats::maxMana);
}

uint32_t Unit::GetUnitHealth(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);

	if (!unit)
		return 0;

	uint32_t health = *(uint32_t*)((UINT_PTR)unit + Patterns.Offset_Health) / 100;

	return health;
}

uint32_t Unit::GetUnitMaxHealth(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);

	if (!unit)
		return 0;

	return X2::W_GetUnitStats(unit, stats::maxHealth);
}

float Unit::GetHealthPercentage(uint32_t unitId)
{
	return (float)GetUnitHealth(unitId) / (float)GetUnitMaxHealth(unitId);
}

float Unit::GetManaPercentage(uint32_t unitId)
{
	return (float)GetUnitMana(unitId) / (float)GetUnitMaxMana(unitId);
}

bool Unit::IsUnitInCombat(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);

	if (!unit)
		return 0;

	return *(bool*)((UINT_PTR)unit + Patterns.Offset_IsUnitInCombat);
}

bool Unit::IsUnitDead(uint32_t unitId)
{
	UINT_PTR* unit = GetUnitById(unitId);

	if (!unit)
		return 0;

	return *(bool*)((UINT_PTR)unit + Patterns.Offset_isDead);
}
