#include "pch.h"
#include "GameClasses.h"
#include "Helper.h"
#include "Skills.h"
#include "Game.h"
#include "Combat.h"

extern Addr Patterns;


BOOL Stats::has_buff(uint32_t buffID)
{
	return X2::W_AI_CheckBuff(NULL, LocalPlayerFinder::GetClientActor()->unitID, buffID);
}

UINT_PTR Combat::get_local_unit()
{
	return *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);
}

bool is_monster_name_already_in_list(std::vector<IActor*> list, const char * name)
{
	if (list.empty())
		return false;
	else
	{
		for (auto& element : list) {
			if (strcmp(element->Entity->GetName(), name) == 0)
			{
				return true;
			}
		}
		return false;
	}
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

std::vector<IActor*> Combat::get_unique_mob_list()
{
	std::vector<IActor*> Aggro_Actors;
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && EntityHelper::isHostile(actor->Entity) && !is_monster_name_already_in_list(Aggro_Actors, actor->Entity->GetName()))
		{
			Aggro_Actors.push_back(actor);
		}
	}

	return Aggro_Actors;
}

void* Combat::get_unit_by_id(DWORD targetId)
{
	return (void*)X2::W_GetClientUnit(targetId);
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
				return X2::W_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
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
				return X2::W_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
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
			return X2::W_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
		}
	}
}

BOOL Combat::is_casting()
{
	return X2::W_AI_IsCasting(NULL, LocalPlayerFinder::GetClientActor()->unitID);
}

BOOL Combat::is_channeling()
{
	return X2::W_AI_IsChanneling(NULL, LocalPlayerFinder::GetClientActor()->unitID);
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
	UINT_PTR Unit = X2::W_GetClientUnit(unitID);
	return *(bool*)((UINT_PTR)Unit + (UINT_PTR)Patterns.Offset_isDead);
}

BOOL Combat::is_targeting_me(DWORD unitID)
{
	DWORD local_UnitId = LocalPlayerFinder::GetClientActor()->unitID;
	UINT_PTR MobUnit = X2::W_GetClientUnit(unitID);
	DWORD unitCurrentTarget = *(DWORD*)((UINT_PTR)MobUnit + (UINT_PTR)Patterns.Offset_CurrentTargetId);

	if (unitCurrentTarget == local_UnitId)
		return true;
	return false;
}

BOOL Combat::stop_casting() // not sure what this is supposed to return
{
	X2::W_AI_StopCasting(NULL, LocalPlayerFinder::GetClientActor()->unitID);
	return true;
}

BOOL Combat::isRunning()
{
	for (int i = 0; i < 6; i++)
	{
		if (X2::W_VelocityOfIndex(i) > 0.0f)
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
		return X2::W_isLootable(lootClass, unitId);
	}
	else
		return false;
}

BOOL Loot::loot_all()
{
	return X2::W_loot_all(0);
}

BOOL Navigation::move_to_position(Vec3 position)
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
	X2::W_GetNavPath_and_Move(ActorUnitModel, &position);

	return true;
}


int World::GetCurrentStage()
{
	return *(int*)Patterns.Addr_GameStage;
}

int World::GetCurrentTransition()
{
	return *(int*)Patterns.Addr_TransitionStage;
}

const char* World::GetCurrentStageStr()
{

	if (GetCurrentTransition() != 0)
		return "Screen Transitioning";

	GameStage stage = (GameStage)GetCurrentStage();

	switch (stage)
	{
	case Not_Loaded:
		return "Not Loaded";
		break;
	case Splash_Logo:
		return "Splash Logo";
		break;
	case PreServer_Select:
		return "Pre-Server Selection";
		break;
	case Server_Select:
		return "Server Selection";
		break;
	case Character_Select:
		return "Character Selection";
		break;
	case Character_Creation:
		return "Character Creation";
		break;
	case SetCustomize_CharacterPos:
		return "SetCustomizeCharacterPos";
		break;
	case In_Game:
		return "In Game";
		break;
	default:
		return "Unknown";
		break;
	}
}
