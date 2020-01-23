#include "pch.h"
#include "GameClasses.h"
#include "Combat.h"
#include "Helper.h"
#include "Game.h"

X2 x2;  extern Addr Patterns;

BOOL Stats::has_buff(uint32_t buffID)
{
	return x2.o_AI_CheckBuff(NULL, LocalPlayerFinder::GetClientActor()->unitID, buffID);
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

IActor* Combat::get_closest_monster_npc(float maxRange)
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
}

IActor* Combat::get_closest_player(float maxRange)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isPlayer(actor->Entity))
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
}

IActor* Combat::get_closest_lootable(float maxRange)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && is_dead(actor->unitID) && Loot::is_lootable(actor->unitID))
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
}

std::vector<IActor*> Combat::get_aggro_mob_list()
{
	std::vector<IActor*> Aggro_Actors;
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && EntityHelper::isHostile(actor->Entity) && is_targeting_me(actor->unitID))
		{
			Aggro_Actors.push_back(actor);
		}
	}

	return Aggro_Actors;
}

void* Combat::get_unit_by_id(DWORD targetId)
{
	return (void*)x2.o_GetClientUnit(targetId);
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
				return x2.o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
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
				return x2.o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
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
			return x2.o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
		}
	}
}

BOOL Combat::is_casting()
{
	return x2.o_AI_IsCasting(NULL, LocalPlayerFinder::GetClientActor()->unitID);
}

BOOL Combat::is_channeling()
{
	return x2.o_AI_IsChanneling(NULL, LocalPlayerFinder::GetClientActor()->unitID);
}

BOOL Combat::is_in_combat()
{
	UINT_PTR LocalUnit = get_local_unit();

	if(LocalUnit)
		return *(BYTE*)(LocalUnit + Patterns.Offset_isInCombat);

	return false;
}

BOOL Combat::is_dead(DWORD unitID)
{
	UINT_PTR Unit = x2.o_GetClientUnit(unitID);
	return *(bool*)((UINT_PTR)Unit + (UINT_PTR)Patterns.Offset_isDead);
}

BOOL Combat::is_targeting_me(DWORD unitID)
{
	DWORD local_UnitId = LocalPlayerFinder::GetClientActor()->unitID;
	UINT_PTR MobUnit = x2.o_GetClientUnit(unitID);
	DWORD unitCurrentTarget = *(DWORD*)((UINT_PTR)MobUnit + (UINT_PTR)Patterns.Offset_CurrentTargetId);

	if (unitCurrentTarget == local_UnitId)
		return true;
	return false;
}

BOOL Combat::stop_casting() // not sure what this is supposed to return
{
	x2.o_AI_StopCasting(NULL, LocalPlayerFinder::GetClientActor()->unitID);
	return true;
}

BOOL Combat::isRunning()
{
	for (int i = 0; i < 6; i++)
	{
		if (x2.o_VelocityOfIndex(i) > 0.0f)
			return true;
	}
	return false;
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

BOOL Loot::is_lootable(DWORD unitId)
{
	UINT_PTR lootClass = *(UINT_PTR*)Patterns.Addr_LootClass;

	if (lootClass)
	{
		return x2.o_isLootable(lootClass, unitId);
	}
	else
		return false;
}

BOOL Loot::loot_all()
{
	return x2.o_loot_all(0);
}
