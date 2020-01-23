#pragma once

class CombatSettings {
	float min_health_percentage;
};

class Navigation {
	static BOOL move_to_shop();
	static BOOL move_to_next_target(DWORD TargetId);
	static BOOL move_to_repair();
	static BOOL move_to_bank();
};

class Interaction {
	static BOOL interact_with_npc_id(DWORD npcId);
	static BOOL uninteract_with_npc();
	static BOOL is_interacting();
};

class Stats
{
public:
	static int get_health();
	static int get_max_health();
	static int get_mana();
	static int get_max_mana();

	static BOOL has_buff(uint32_t buffID);
};

class Combat {
public:

	static UINT_PTR get_entitylist_ptr();
	static UINT_PTR get_local_unit();

	static IActor* get_closest_monster_npc(float maxRange);
	static IActor* get_closest_player(float maxRange);
	static IActor* get_closest_lootable(float maxRange);

	static DWORD get_closest_targetid(float maxRange);
	static DWORD get_closest_target_with_type(DWORD TargetType, float maxRange);
	static DWORD get_targets_with_name(char * TargetName, float maxRange);

	static std::vector<IActor*> get_aggro_mob_list();

	static void* get_unit_by_id(DWORD targetId);
	static DWORD get_current_target_id();
	static BOOL  set_current_target(DWORD targetId);

	static BOOL  cast_skill_on_targetId(DWORD TargetId, DWORD SkillId);
	static BOOL  cast_skill_on_current_target(DWORD SkillId);
	static BOOL  cast_skill_on_self(DWORD SkillId);

	static BOOL  isRunning();
	static BOOL  isStuck();
	static BOOL  is_casting();
	static BOOL  is_channeling();
	static BOOL  is_in_combat();
	static BOOL  is_dead(DWORD unitID);
	static BOOL  is_targeting_me(DWORD unitID);

	static BOOL  need_heal();

	static BOOL  stop_casting();
	static BOOL  stop_channeling();
};

class Loot {
public:
	static BOOL is_lootable(DWORD unitId);
	static BOOL loot_all();
};

class Inventory {
	static DWORD find_item_slot_by_name(char* itemName);
	static BOOL  use_item(DWORD slotId);
	static BOOL  move_item(DWORD from_slot, DWORD to_slot);
	static BOOL  move_to_bank(DWORD slotId);
	static BOOL  withdraw_from_bank(DWORD slotId);
	static BOOL  sell_to_npc(DWORD npcId, DWORD slot);
	static BOOL  buy_from_npc(DWORD npcId, DWORD itemId);
};

class Stealth {
	static BOOL is_player_nearby(float range);
	static BOOL escape_from_player();
};

class Skill {
	static DWORD * get_learned_skills_list();
	static DWORD   get_skill_id_by_name(char* skillName);
	
	static BOOL is_skill_on_cooldown(DWORD skillId);
	static BOOL is_skill_useable(DWORD skillId);
	static 	BOOL is_skill_learned(DWORD skillId);
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