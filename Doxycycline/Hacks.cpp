#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"

bool bFlyHack = false;
bool bNoFallDamage;
float speedMultiplier = 1.0;
bool bRadar = true;
extern Addr Patterns;

void SetPlayerSpeed(float speed)
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
