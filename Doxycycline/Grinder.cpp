#include "pch.h"
#include "GameClasses.h"
#include "Combat.h"
#include "Menu.h"
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

		auto fp = std::bind(&Grinding::Hide, this);
		Ai.setState(fp);
	}

}

void Grinding::Idle()
{
	BotStatus = "Grindbot - Idling...";

}

void Grinding::Wander()
{
	BotStatus = "Grindbot - Wandering...";

}

void Grinding::Fight()
{
	BotStatus = "Grindbot - Fighting...";


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

bool Grinding::needHeal()
{
	auto localPlayer = LocalPlayerFinder::GetClientEntity();

	return false;
}
