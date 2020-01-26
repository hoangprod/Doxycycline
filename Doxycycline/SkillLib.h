#pragma once

struct DoxySkill
{
	DoxySkill(uint32_t id, const char* name, uint32_t mana, uint32_t range, uint32_t cd, uint32_t casttime, uint32_t channelTime, uint32_t radius) :
		SkillId(id), SkillName(name), manaCost(mana), maxRange(range), cooldown(cd), castingTime(casttime), channelingTime(channelTime), targetRadius(radius) {}
	uint32_t SkillId;
	std::string SkillName;
	uint32_t manaCost;
	uint32_t maxRange;
	uint32_t cooldown;
	uint32_t castingTime;
	uint32_t channelingTime;
	uint32_t targetRadius;
};

int test;