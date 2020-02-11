#include "pch.h"
#include "GameClasses.h"
#include "Helper.h"
#include "Skills.h"
#include "Game.h"
#include "Inventory.h"
#include "Unit.h"
#include "Combat.h"

extern Addr Patterns;

bool stringExistInVector(std::string name, std::vector<std::string> vector)
{
	if (std::find(vector.begin(), vector.end(), name) != vector.end())
	{
		return true;
	}
	
	return false;
}

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
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && actor->unitID && !Combat::is_dead(actor->unitID) && Combat::is_targetable(actor->unitID) && EntityHelper::isHostile(actor->Entity))
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

IActor* Combat::get_closest_monster_filtered(float maxRange, std::vector<std::string> whitelist, std::vector<std::string> blacklist)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		// Actor and Entity exist, is a mob, is hostile, in whitelist and not in blacklist
		if (actor && actor->Entity && EntityHelper::isNpcMob(actor->Entity) && actor->unitID != 0 && !Combat::is_dead(actor->unitID) && Combat::is_targetable(actor->unitID) && EntityHelper::isHostile(actor->Entity) &&
			stringExistInVector(actor->Entity->GetName(), whitelist) && !stringExistInVector(actor->Entity->GetName(), blacklist))
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

bool Combat::is_player_nearby(float maxRange)
{
	IActor* player = get_closest_player(maxRange);

	return player != 0;
}

std::vector<std::string> invulnerable_skill = { "Untouchable" };

bool Combat::is_targetable(uint32_t targetId)
{
	uint32_t buffCount = Unit::GetBuffCount(targetId, 1);

	if (buffCount > 0)
	{
		for (int j = 0; j < buffCount; j++)
		{
			auto buff = Unit::GetBuffInfo(targetId, 1, j);

			if (!buff)
				return false;

			if (stringExistInVector(buff->BuffName, invulnerable_skill))
				return false;
		}

		return true;
	}

	if (buffCount == 0)
		return true;
}

uint32_t Combat::get_closest_mob_targetid(float maxRange)
{
	auto target = get_closest_monster_npc(maxRange);

	if (!target)
		return 0;

	return target->unitID;
}


uint32_t Combat::get_closest_targetId_with_name(char* TargetName, float maxRange)
{
	std::map<IActor*, float> viableActors;
	Vec3 localPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();
	auto actorList = LocalPlayerFinder::GetActorList();
	for (auto actor : actorList)
	{
		if (actor && actor->Entity && iequals(TargetName, actor->Entity->GetName()))
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

	auto target = get_closest_actor_from_map(viableActors);

	if (!target)
		return 0;

	return target->unitID;
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

void* Combat::get_unit_by_id(uint32_t targetId)
{
	return (void*)X2::W_GetUnitById(targetId);
}

uint32_t Combat::get_current_target_id()
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return 0;

	return *(uint32_t*)(LocalUnit + Patterns.Offset_CurrentTargetId);
}

BOOL Combat::set_current_target(uint32_t targetId)
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return false;

	*(DWORD*)(LocalUnit + Patterns.Offset_CurrentTargetId) = targetId;

	return true;
}

BOOL Combat::cast_skill_on_targetId(uint32_t targetId, uint32_t SkillId)
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

BOOL Combat::cast_skill_on_current_target(uint32_t SkillId)
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

BOOL Combat::cast_skill_on_self(uint32_t SkillId)
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

BOOL Combat::is_dead(uint32_t unitID)
{
	UINT_PTR Unit = X2::W_GetUnitById(unitID);

	// Assume unit is dead if we can't get Unit from Id
	if (!Unit)
		return true;

	return *(bool*)((UINT_PTR)Unit + (UINT_PTR)Patterns.Offset_isDead);
}

BOOL Combat::is_targeting_me(uint32_t unitID)
{
	DWORD local_UnitId = LocalPlayerFinder::GetClientActor()->unitID;
	UINT_PTR MobUnit = X2::W_GetUnitById(unitID);

	if (!MobUnit)
		return false;

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

BOOL Navigation::move_to_target(IActor* Target)
{
	if(!Target)
		return 0;

	return move_to_position(Target->Entity->GetWorldPos());
}

bool Navigation::isAutoPathing()
{
	if(!Patterns.Addr_isAutoPathing)
		return true;
	else
	{
		return *Patterns.Addr_isAutoPathing;
	}
}

float Navigation::get_distance(IActor* one, IActor* Two)
{
	if (!one || !Two)
		return 0.0f;

	Vec3 pos1 = one->Entity->GetWorldPos();
	Vec3 pos2 = Two->Entity->GetWorldPos();

	return sqrtf(pow((pos1.x - pos2.x), 2) + pow((pos1.y - pos2.y), 2) + pow((pos1.z - pos2.z), 2));
}

float Navigation::get_distance(Vec3 start, Vec3 end)
{
	return sqrtf(pow((start.x - end.x), 2) + pow((start.y - end.y), 2) + pow((start.z - end.z), 2));
}

int Navigation::get_next_path(Vec3 currentPos, std::vector<Vec3> * path_list, bool reverse)
{
	if (path_list && !path_list->empty())
	{
		int closestVectorIndex = -1;
		float closestDistance = 999999999.f;

		for (int i = 0; i < path_list->size(); i++)
		{
			float curDistance = get_distance(currentPos, (*path_list)[i]);

			if (curDistance <= closestDistance)
			{
				closestDistance = curDistance;
				closestVectorIndex = i;
			}

		}

		// If the closest path is between 20 and 2000 units, this is the one we want to walk to
		if (closestDistance > 20.0f && closestDistance < 2000.0f)
		{
			printf("1 %f\n", closestDistance);
			return  closestVectorIndex;
		}

		// If found a valid closest path is super close to us, then we want to go to the next point
		if (closestVectorIndex != -1)
		{
			// Go to the next point
			closestVectorIndex++;

			// If the next point does not exist because we have reached the end of the list, go back to the beginning
			if (closestVectorIndex >= path_list->size())
			{
				printf("2 %d %d\n", closestVectorIndex, path_list->size());

				// If reverse is true, then we will backtrace our steps and reverse the path_list
				if (reverse)
				{
					printf("reversin\n");
					std::reverse(std::begin(*path_list), std::end(*path_list));
				}

				// Go to the first path item, if it was not inverse, then it is first in the list added, if it is inversed - it is the last in the list
				return  0;
			}


			printf("3 %d\n", closestVectorIndex);
			// Next point does exist, we will just walk there
			return closestVectorIndex;
		}

	}

	printf("could not find\n");

	// Could not find a closest path item
	return -1;
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
