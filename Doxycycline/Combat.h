#pragma once

class CombatSettings {
	float min_health_percentage;
};

class Navigation {
	BOOL move_to_shop();
	BOOL move_to_next_target(DWORD TargetId);
	BOOL move_to_repair();
	BOOL move_to_bank();
};

class Interaction {
	BOOL interact_with_npc_id(DWORD npcId);
	BOOL uninteract_with_npc();
	BOOL is_interacting();
};

class Stats
{
public:
	int get_health();
	int get_max_health();
	int get_mana();
	int get_max_mana();

	BOOL has_buff(uint32_t buffID);
};

class Combat {
public:
	Combat();

	UINT_PTR get_entitylist_ptr();
	UINT_PTR get_local_unit();

	IActor* get_closest_monster_npc(float maxRange);
	IActor* get_closest_player(float maxRange);
	IActor* get_closest_lootable(float maxRange);

	DWORD get_closest_targetid(float maxRange);
	DWORD get_closest_target_with_type(DWORD TargetType, float maxRange);
	DWORD get_targets_with_name(char * TargetName, float maxRange);

	std::vector<IActor*> get_aggro_mob_list();

	DWORD get_current_target_id();
	BOOL  set_current_target(DWORD targetId);

	BOOL  cast_skill_on_targetId(DWORD TargetId, DWORD SkillId);
	BOOL  cast_skill_on_current_target(DWORD SkillId);
	BOOL  cast_skill_on_self(DWORD SkillId);

	BOOL  isRunning();
	BOOL  isStuck();
	BOOL  is_casting();
	BOOL  is_channeling();
	BOOL  is_in_combat();
	BOOL  is_dead(DWORD NetworkID);
	BOOL  is_targeting_me(DWORD NetworkId);

	BOOL  need_heal();

	BOOL  stop_casting();
	BOOL  stop_channeling();
};

class Inventory {
	DWORD find_item_slot_by_name(char* itemName);
	BOOL  use_item(DWORD slotId);
	BOOL  move_item(DWORD from_slot, DWORD to_slot);
	BOOL  move_to_bank(DWORD slotId);
	BOOL  withdraw_from_bank(DWORD slotId);
	BOOL  sell_to_npc(DWORD npcId, DWORD slot);
	BOOL  buy_from_npc(DWORD npcId, DWORD itemId);
};

class Stealth {
	BOOL is_player_nearby(float range);
	BOOL escape_from_player();
};

class Skill {
	DWORD * get_learned_skills_list();
	DWORD   get_skill_id_by_name(char* skillName);
	
	BOOL is_skill_on_cooldown(DWORD skillId);
	BOOL is_skill_useable(DWORD skillId);
	BOOL is_skill_learned(DWORD skillId);
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