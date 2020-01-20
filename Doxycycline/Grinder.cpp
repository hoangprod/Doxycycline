#include "pch.h"
#include "GameClasses.h"
#include "Combat.h"
#include "Grinder.h"

void Grinding::Idle()
{
	BotStatus = "Grindbot - Idling...";

	if (playerDetection && combat.get_closest_player(75.0f))
	{
		auto fp = std::bind(&Grinding::Hide, this);
		Ai.setState(fp);
	}

	else if (false) // if ready to go bank
	{
		auto fp = std::bind(&Grinding::Bank, this);
		Ai.setState(fp);
	}

	else
	{
		auto fp = std::bind(&Grinding::Wander, this);
		Ai.setState(fp);
	}
}

void Grinding::Wander()
{
	BotStatus = "Grindbot - Wandering...";

	if (playerDetection && combat.get_closest_player(75.0f))
	{
		auto fp = std::bind(&Grinding::Hide, this);
		Ai.setState(fp);
	}

	else if (false) 	// if low health, go to heal
	{
		auto fp = std::bind(&Grinding::Heal, this);
		Ai.setState(fp);
	}

	else if (false)   // if ready to go bank
	{
		auto fp = std::bind(&Grinding::Bank, this);
		Ai.setState(fp);
	}

	else if (combat.get_closest_monster_npc(60.0f)) // Use setting as well as integrate whitelist/blacklist later
	{
		auto fp = std::bind(&Grinding::Fight, this);
		Ai.setState(fp);
	}

	else
	{
		// perform wandering logic, walk around, etc
	}
}

void Grinding::Fight()
{
	BotStatus = "Grindbot - Fighting...";

	if (playerDetection && combat.get_closest_player(75.0f))
	{
		auto fp = std::bind(&Grinding::Hide, this);
		Ai.setState(fp);
	}
	else if (false) // check if low health
	{
		auto fp = std::bind(&Grinding::Heal, this);
		Ai.setState(fp);
	}
	else if(IActor* target = combat.get_closest_monster_npc(60.0f))
	{
		// Fight logic
	}
	else
	{
		// Cannot find any monster, wander
		auto fp = std::bind(&Grinding::Wander, this);
		Ai.setState(fp);
	}

}

void Grinding::Bank()
{

}

void Grinding::Heal()
{

}

void Grinding::Hide()
{

}
