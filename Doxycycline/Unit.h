#pragma once

enum stats
{
	maxHealth = 6,
	maxMana = 7
};


class Unit {
public:
	static UINT_PTR* GetLocalPlayerUnitClass();
	static UINT_PTR* GetUnitById(uint32_t unitId);

	static uint32_t GetLocalPlayerUnitId();
	static uint32_t GetUnitMana(uint32_t unitId);
	static uint32_t GetUnitMaxMana(uint32_t unitId);
	static uint32_t GetUnitHealth(uint32_t unitId);
	static uint32_t GetUnitMaxHealth(uint32_t unitId);

	static float GetHealthPercentage(uint32_t unitId);
	static float GetManaPercentage(uint32_t unitId);

	static bool IsUnitInCombat(uint32_t unitId);
	static bool IsUnitDead(uint32_t unitId);

	static UINT_PTR* GetBuffManager(uint32_t unitId);
	static Buff* GetBuffInfo(uint32_t unitId, int debuffOrBuff, int buffSlot);
	static UINT_PTR GetBuffCount(uint32_t unitId, int debuffOrBuff);
	static UINT_PTR* GetBuffClassPtr(uint32_t unitId, int debuffOrBuff, int buffSlot);
};