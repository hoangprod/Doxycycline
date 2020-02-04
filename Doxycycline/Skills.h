#pragma once

class Skill {
public:
	static std::vector<ISkill*> get_learned_skills_list();
	static std::vector<ISkill*> get_skill_id_by_name(char* skillName);

	static void initialize_skill_list();

	static ISkill* get_skill_by_id(uint32_t skillId);

	static int32_t get_skill_cooldown(uint32_t skillId);
	static uint32_t get_skill_maxRange(uint32_t skillId);
	static uint32_t get_skill_minRange(uint32_t skillId);

	static BOOL is_skill_on_cooldown(DWORD skillId);
	static BOOL is_skill_useable(DWORD skillId);
	static BOOL is_skill_learned(DWORD skillId);
};

class SkillCastInformation {
public:
	SkillCastInformation(DWORD info) : One(0), one_2(1), Info(info), Three(0), Four(0) {};
	DWORD One;
	DWORD one_2;
	UINT_PTR Info;
	UINT_PTR Three;
	UINT_PTR Four;
};