#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"

bool bFlyHack = false;
bool bNoFallDamage;
float speedMultiplier = 1.0;

void SetPlayerSpeed(float speed)
{
	static char* speedModifierOffset = NULL;

	if (!speedModifierOffset)
	{
		speedModifierOffset = ptr_offset_Scanner((char*)HdnGetModuleBase("crysystem.dll"), 0x100000, "\xf3\x44\xCC\xCC\xCC\xCC\xCC\xCC\x00\x84\xc0\x0f\x84\xCC\x00\x00\x00\x48\x8b\x06\x48\x8b\xce", 0, 9, 5, "xx??????xxxxx?xxxxxxxxx");
	}

	float* pSpeed = (float*)(speedModifierOffset);
	*pSpeed = speed;
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