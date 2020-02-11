#include "pch.h"
#include "GameClasses.h"
#include "Combat.h"
#include "Menu.h"
#include "Unit.h"
#include "Inventory.h"
#include "Skills.h"
#include "Game.h"
#include "Grinder.h"

extern Settings settings;

void Grinding::States()
{
	static bool isHiding = false;


	// If 150 ticks have not past yet
	if ((lastTick + tick) > GetTickCount64())
		return;

	lastTick = GetTickCount64();

	if (settings.hide_from_players && Combat::is_player_nearby(100.0f))
	{
		isHiding = true;

		Grinding::Hide();
	}


	else if ((needHeal() || needMana()) && (!Combat::is_casting() && !Combat::is_channeling()))
	{
		Grinding::Heal();
	}

	// Avoid actions if hiding underground / wherever
	else if (isHiding)
		return;

	// If want to deposit item, not in combat, and bag is full
	else if (settings.deposit_items && !Unit::IsUnitInCombat(Unit::GetLocalPlayerUnitId()) && Inventory::is_bag_full())
	{
		// If both bag and bank is full, stop grinding.
		if (Inventory::is_bank_full())
		{
			console.AddLog("[GrindBot] - Bank and Inventory is full. Stopping bot.\n");
			settings.grinding_bot_on = false;
		}

		Grinding::Bank();
	}

	else if (settings.loot_items && !Unit::IsUnitInCombat(Unit::GetLocalPlayerUnitId()) && Combat::get_closest_lootable(15.0f))
	{
		Grinding::Loot();
	}

	else if (Unit::IsUnitInCombat(Unit::GetLocalPlayerUnitId()) || Combat::get_closest_monster_filtered(settings.max_wander_range, settings.whitelist_monsters, settings.blacklist_monsters))
	{
		Grinding::Fight();
	}

	else if (!Combat::get_closest_monster_filtered(settings.max_wander_range, settings.whitelist_monsters, settings.blacklist_monsters))
	{
		Grinding::Wander();
	}

}

void Grinding::Wander()
{
	BotStatus = "Grindbot - Wandering...";

	if (Combat::is_casting() || Combat::is_channeling() || Combat::isRunning() || Navigation::isAutoPathing())
	{
		return;
	}

	Vec3 ourPos = LocalPlayerFinder::GetClientActor()->Entity->GetWorldPos();

	int nextPathIndex = Navigation::get_next_path(ourPos, &settings.wander_path_list, settings.go_back_to_beginning);

	if (nextPathIndex != -1 && !Combat::isRunning() && !Navigation::isAutoPathing())
	{
		Vec3 currentDestination = settings.wander_path_list[nextPathIndex];

		printf("moving to %f %f %f at index %d and distance %f\n", currentDestination.x, currentDestination.z, currentDestination.y, nextPathIndex, Navigation::get_distance(ourPos, currentDestination));

		if (settings.teleport_to_next_mob && Navigation::get_distance(ourPos, currentDestination) < 10.0f)
			LocalPlayerFinder::GetClientActor()->Entity->SetPos(currentDestination, 0);
		else
			Navigation::move_to_position(currentDestination);
	}
	else
	{
		console.AddLog("[Grinder] - Cannot find a valid next path\n");
	}
}

void Grinding::Fight()
{
	BotStatus = "Grindbot - Fighting...";

	if (Combat::is_casting() || Combat::is_channeling())
	{
		printf("Casting or channeling...\n");
		return;
	}

	// Must check if target is in whitelist / not in blacklist
	auto Target = Combat::get_closest_monster_filtered(settings.max_wander_range, settings.whitelist_monsters, settings.blacklist_monsters);

	if (!Target || Target->unitID == 0)
		return;

	for (auto element : settings.attack_spell_list) {

		if (Combat::is_dead(Target->unitID))
		{
			return;
		}

		// If skill is not off cd
		if (!Skill::is_skill_off_cd(element->SkillId))
		{
			continue;
		}

		CSkill skillInfo;

		// If can't get skill info
		if (!Skill::get_skill_info(element->SkillId, &skillInfo))
		{
			continue;
		}

		//if (skillInfo.minRange == 0.0f && skillInfo.maxRange == 0.0f)
		//	skillInfo.maxRange = Skill::get_skill_effective_range(element->SkillId);

		// If Not enough mana
		if (skillInfo.ManaCost > Unit::GetUnitMana(Unit::GetLocalPlayerUnitId()))
		{
			continue;
		}

		float distance_to_target = Navigation::get_distance(Target, LocalPlayerFinder::GetClientActor());

		// Implement a walk away later? idk this is for very niche skills
		if (distance_to_target < skillInfo.minRange)
		{
			continue;
		}
		// We do not want to keep running at target
		if (distance_to_target > skillInfo.maxRange && distance_to_target > 2.0f)
		{
			if (distance_to_target < 30.0f && settings.teleport_to_next_mob)
			{
				LocalPlayerFinder::GetClientActor()->Entity->SetPos(Target->Entity->GetWorldPos(), 0);
			}
			else
			{
				Navigation::move_to_target(Target);
			}
		}

		if (distance_to_target > skillInfo.minRange && (distance_to_target < skillInfo.maxRange || distance_to_target < skillInfo.effectiveRange))
		{
			if (!Combat::is_dead(Target->unitID))
			{
				if (skillInfo.maxRange == 0.0f && skillInfo.effectiveRange > 0.0f)
					Combat::cast_skill_on_self(skillInfo.SkillId);
				else
					Combat::cast_skill_on_targetId(Target->unitID, element->SkillId);
			}
		}
	}
}

void Grinding::Bank()
{
	BotStatus = "Grindbot - Banking...";

	for (auto element : settings.store_item_list) {
		if (Inventory::is_bank_full())
			return;

		auto slot = Inventory::find_bag_item_slot_by_itemId(element);

		Inventory::move_item_to_bank(slot);
	}
}

void Grinding::Heal()
{
	BotStatus = "Grindbot - Healing...";

	for (auto element : settings.recover_hp_spell_list) {
		if (!needHeal())
			break;

		// If skill on cooldown
		if (!Skill::is_skill_off_cd(element->SkillId))
			continue;

		CSkill skillInfo;
		
		// If can't get skill info
		if (!Skill::get_skill_info(element->SkillId, &skillInfo))
			continue;

		// If Not enough mana
		if (skillInfo.ManaCost > Unit::GetUnitMana(Unit::GetLocalPlayerUnitId()))
			continue;

		Combat::cast_skill_on_self(element->SkillId);

		break;
	}


	for (auto element : settings.recover_hp_item_list) {
		if (!needHeal())
			break;

		auto itemSlot = Inventory::find_bag_item_slot_by_itemId(element);

		if (!itemSlot)
		{
			continue;
		}

		auto item = Inventory::get_bag_item_informationEX(itemSlot);

		if (!item)
		{
			continue;
		}

		// If item on cooldown
		if (!Skill::is_skill_off_cd(item->skillType))
		{
			continue;
		}

		Inventory::use_item_by_itemId(element);

		break;
	}

	for (auto element : settings.recover_mp_spell_list) {
		if (!needMana())
			break;

		// If skill on cooldown
		if (!Skill::is_skill_off_cd(element->SkillId))
			continue;

		CSkill skillInfo;

		// If can't get skill info
		if (!Skill::get_skill_info(element->SkillId, &skillInfo))
			continue;

		// If Not enough mana
		if (skillInfo.ManaCost > Unit::GetUnitMana(Unit::GetLocalPlayerUnitId()))
			continue;

		Combat::cast_skill_on_self(element->SkillId);

		break;
	}


	for (auto element : settings.recover_mp_item_list) {
		if (!needMana())
			break;

		auto itemSlot = Inventory::find_bag_item_slot_by_itemId(element);

		if (!itemSlot)
			continue;

		auto item = Inventory::get_bag_item_informationEX(itemSlot);

		if (!item)
			continue;

		// If item on cooldown
		if (!Skill::is_skill_off_cd(item->skillType))
			continue;

		Inventory::use_item_by_itemId(element);

		break;
	}

}

void Grinding::Buff()
{
	BotStatus = "Grindbot - Buffing...";

	for (auto element : settings.buff_spell_list) {
		// If skill on cooldown
		if (Skill::is_skill_off_cd(element->SkillId))
			continue;

		CSkill skillInfo;

		// If can't get skill info
		if (!Skill::get_skill_info(element->SkillId, &skillInfo))
			continue;

		// If Not enough mana
		if (skillInfo.ManaCost > Unit::GetUnitMana(Unit::GetLocalPlayerUnitId()))
			continue;

		Combat::cast_skill_on_self(element->SkillId);
	}
}

void Grinding::Hide()
{
	BotStatus = "Grindbot - Hiding...";

}

void Grinding::Loot()
{
	BotStatus = "Grindbot - Looting...";

	auto lootable = Combat::get_closest_lootable(15.0f);

	if (!lootable)
		return;

	float distance = Navigation::get_distance(LocalPlayerFinder::GetClientActor(), lootable);

	if (distance > 3.0f)
		Navigation::move_to_position(lootable->Entity->GetWorldPos());
	else
		Loot::loot_all();

	return;
}

bool Grinding::needHeal()
{
	return Unit::GetHealthPercentage(Unit::GetLocalPlayerUnitId()) < settings.min_health_percentage;
}

bool Grinding::needMana()
{
	return Unit::GetManaPercentage(Unit::GetLocalPlayerUnitId()) < settings.min_mana_percentage;
}
