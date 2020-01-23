#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "PathFinder.h"

extern X2 x2;
extern Addr Patterns;

bool PathToPosition(Vec3 Position)
{
	// Set auto pathing on
	*Patterns.Addr_isAutoPathing = (BYTE)1;

	UINT_PTR LocalUnit = *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);

	if (!LocalUnit)
	{
		return false;
	}

	UINT_PTR* ActorUnitModel = *(UINT_PTR**)(LocalUnit + Patterns.Offset_ActorUnitModel);

	if (!ActorUnitModel)
	{
		return false;
	}
	x2.o_GetNavPath_and_Move(ActorUnitModel, &Position);

	return true;
}