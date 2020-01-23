#include "pch.h"
#include "Helper.h"
#include "GameClasses.h"

extern Addr Patterns;

SSystemGlobalEnvironment* SSystemGlobalEnvironment::GetInstance()
{
	return *(SSystemGlobalEnvironment**)(Patterns.Addr_gEnv);
}

Vec3 IEntity::GetFixedAngles()
{
	Vec3 angles = GetWorldAngles();
	if (angles.y < 0)
	{
		angles.y = 6.28319 + angles.y;
	}

	float rad2deg = angles.y * (180.0 / m_PI);
	angles.y = 360 - rad2deg;
	return angles;
}
