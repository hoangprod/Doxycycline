#include "pch.h"
#include "GameClasses.h"
#include "Combat.h"
#include "Helper.h"
#include <map>
#include <iterator>
extern Addr Patterns;

typedef __int64(__fastcall* f_GetClientUnit)(unsigned int UnitId);
typedef char(__fastcall* f_UseSkillWrapper)(__int64 null, unsigned int skillId, __int64 Struct, char null_1, char null_2, char null_3);

typedef BOOL(__fastcall* f_AI_IsCasting)(void* nullParam, int networkID);
typedef void*(__fastcall* f_AI_StopCasting)(void* nullParam, int networkID);
typedef BOOL(__fastcall* f_AI_IsChanneling)(void* nullParam, int networkID);
typedef void*(__fastcall* f_AI_GetGlobalCooldown)(void* nullParam, int networkID); // not sure if this returns a 4 byte or 8 byte value
typedef bool(__fastcall* f_AI_CheckBuff)(void* nullParam, int networkID, uint32_t buffID);

f_GetClientUnit o_GetClientUnit = NULL;
f_UseSkillWrapper o_UseSkillWrapper = NULL;

f_AI_IsCasting o_AI_IsCasting;
f_AI_StopCasting o_AI_StopCasting;
f_AI_IsChanneling o_AI_IsChanneling;
f_AI_GetGlobalCooldown o_AI_GetGlobalCooldown;
f_AI_CheckBuff o_AI_CheckBuff;

BOOL Stats::has_buff(uint32_t buffID)
{
	return o_AI_CheckBuff(NULL, LocalPlayerFinder::GetClientActor()->NetworkID, buffID);
}

Combat::Combat()
{
	o_GetClientUnit = (f_GetClientUnit)Patterns.Func_GetClientUnit;
	o_UseSkillWrapper = (f_UseSkillWrapper)Patterns.Func_CastSkillWrapper;
	
	o_AI_IsCasting = (f_AI_IsCasting)Patterns.Func_AI_IsCasting;
	o_AI_StopCasting = (f_AI_StopCasting)Patterns.Func_AI_StopCasting;
	o_AI_IsChanneling = (f_AI_IsChanneling)Patterns.Func_AI_IsChanneling;
	o_AI_GetGlobalCooldown = (f_AI_GetGlobalCooldown)Patterns.Func_AI_GetGlobalCooldown;
	o_AI_CheckBuff = (f_AI_CheckBuff)Patterns.Func_AI_CheckBuff;
}


UINT_PTR Combat::get_local_unit()
{
	return *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);
}

IActor* get_closest_actor_from_map(std::map<IActor*, float> viableActors)
{
	if (!viableActors.empty())
	{
		IActor* closestActor = NULL;
		float closestDistance = 999999999.f;
		std::map<IActor*, float>::iterator it = viableActors.begin();
		while (it != viableActors.end())
		{
			if (it->second <= closestDistance)
			{
				closestActor = it->first;
				closestDistance = it->second;
			}
			it++;
		}

		return closestActor;
	}

	return NULL;
}

IActor* Combat::get_closest_actor(float maxRange)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && EntityHelper::isHostile(actor->Entity))
		{
			Vec3 actorPos = actor->Entity->GetWorldPos();
			float heightDistance = abs(actorPos.y - localPos.y);
			float totalDistance = abs(actorPos.x - localPos.x) + abs(actorPos.z - localPos.z) + heightDistance;
			if (totalDistance <= maxRange && heightDistance <= 35.f)
			{
				viableActors.insert(std::make_pair(actor, totalDistance));
			}
		}
	}

	return get_closest_actor_from_map(viableActors);

	return NULL;
}

DWORD Combat::get_current_target_id()
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return 0;

	return *(DWORD*)(LocalUnit + Patterns.Offset_CurrentTargetId);
}

BOOL Combat::set_current_target(DWORD targetId)
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return false;

	*(DWORD*)(LocalUnit + Patterns.Offset_CurrentTargetId) = targetId;

	return true;
}

BOOL Combat::cast_skill_on_targetId(DWORD targetId, DWORD SkillId)
{
	if (set_current_target(targetId))
	{
		UINT_PTR LocalUnit = get_local_unit();

		if (LocalUnit)
		{
			DWORD info = *(DWORD*)(LocalUnit + 8);

			if (info)
			{
				SkillCastInformation Info(info);
				return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
			}
		}
	}
	return 0;
}

BOOL Combat::cast_skill_on_current_target(DWORD SkillId)
{
	if (get_current_target_id())
	{
		UINT_PTR LocalUnit = get_local_unit();

		if (LocalUnit)
		{
			DWORD info = *(DWORD*)(LocalUnit + 8);

			if (info)
			{
				SkillCastInformation Info(info);
				return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
			}
		}
	}

}

BOOL Combat::cast_skill_on_self(DWORD SkillId)
{
	UINT_PTR LocalUnit = get_local_unit();

	if (LocalUnit)
	{
		DWORD info = *(DWORD*)(LocalUnit + 8);

		if (info)
		{
			SkillCastInformation Info(info);
			return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
		}
	}
}

BOOL Combat::is_casting()
{
	return o_AI_IsCasting(NULL, LocalPlayerFinder::GetClientActor()->NetworkID);
}

BOOL Combat::is_channeling()
{
	return o_AI_IsChanneling(NULL, LocalPlayerFinder::GetClientActor()->NetworkID);
}

BOOL Combat::is_in_combat()
{
	UINT_PTR LocalUnit = get_local_unit();
	return *(BYTE*)(LocalUnit + Patterns.Offset_IsUnitInCombat);
}

BOOL Combat::stop_casting() // not sure what this is supposed to return
{
	o_AI_StopCasting(NULL, LocalPlayerFinder::GetClientActor()->NetworkID);
	return true;
}

BOOL Stealth::is_player_nearby(float range)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isPlayer(actor->Entity))
		{
			Vec3 actorPos = actor->Entity->GetWorldPos();
			float totalDistance = abs(actorPos.x - localPos.x) + abs(actorPos.z - localPos.z);
			if (totalDistance <= range)
			{
				return true;
			}
		}
	}

	return false;
}
