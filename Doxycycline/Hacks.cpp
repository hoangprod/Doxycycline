#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"
#include "Hacks.h"

bool bFlyHack = false;
bool bNoFallDamage;
float speedMultiplier = 1.0f;
float animationMultiplier = 1.0f;
bool bRadar = true;
extern Addr Patterns;

void SetPlayerStatSpeed(float speed)
{
	UINT_PTR LocalUnit = *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);

	if (!LocalUnit)
	{
		return;
	}

	UINT_PTR ActorUnitModel = *(UINT_PTR*)(LocalUnit + Patterns.Offset_ActorUnitModel);

	float * UserStats = *(float**)(ActorUnitModel + Patterns.Offset_UserStats);

	if (!UserStats)
	{
		return;
	}

	UserStats[Patterns.Offset_SpeedStat/4] = speedMultiplier;
}

void SetPlayerAnimationSpeed(float speed)
{
	if (Patterns.Addr_SpeedModifier)
	{
		*(Patterns.Addr_SpeedModifier) = speed;
	}
}

void ToggleNoFall(bool bEnable)
{
	DWORD_PTR IActor = (DWORD_PTR)LocalPlayerFinder::GetClientActor();
	if (IActor)
	{
		float* pFallDamageSafetyNet = (float*)(IActor + 0x184);
		if (bEnable)
		{
			*pFallDamageSafetyNet = 999999.0f;
		}

		else
		{
			*pFallDamageSafetyNet = 0;
		}
	}
}
