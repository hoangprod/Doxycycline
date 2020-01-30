#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "Skills.h"

std::vector<ISkill*> skill_list;


std::vector<ISkill*> Skill::get_skill_id_by_name(char* skillName)
{
	if (skill_list.empty())
		initialize_skill_list();

	std::vector<ISkill*> resultList;
	std::string SkillName = std::string(skillName);
	std::transform(SkillName.begin(), SkillName.end(), SkillName.begin(), ::tolower);

	for (auto& skill : skill_list) {
		std::string curName = std::string(skill->Name);
		std::transform(curName.begin(), curName.end(), curName.begin(), ::tolower);

		if (curName.find(SkillName) != std::string::npos)
		{
			resultList.push_back(skill);
		}
	}
	return resultList;
}

void Skill::initialize_skill_list()
{
	for (int i = 2; i < 500000; i++)
	{
		ISkill* skill = X2::W_get_skill_by_id(i);
		if (skill)
		{
			skill_list.push_back(skill);
		}
	}
}

ISkill* Skill::get_skill_by_id(uint32_t skillId)
{
	if (skill_list.empty())
		initialize_skill_list();

	for (auto& skill : skill_list) {
		if (skill->SkillId == skillId)
			return skill;
	}

}


int32_t Skill::get_skill_cooldown(uint32_t skillId)
{
	ISkill* skill = X2::W_get_skill_by_id(skillId);
	int32_t cooldown = 0;
	int32_t unk2 = 0;
	X2::W_get_skill_cooldown(skill, &cooldown, &unk2);
	return cooldown;
}