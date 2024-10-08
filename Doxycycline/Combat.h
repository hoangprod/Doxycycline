#pragma once

class Navigation {
public:
	static BOOL move_to_shop();
	static BOOL move_to_repair();

	static BOOL move_to_position(Vec3 position);
	static BOOL move_to_target(IActor* Target);

	static bool isAutoPathing();

	static float get_distance(IActor* one, IActor* Two);
	static float get_distance(Vec3 start, Vec3 end);
	static int get_next_path(Vec3 currentPos, std::vector<Vec3> *path_list, bool reverse);
};

enum GameStage {
	Not_Loaded = 0,
	Splash_Logo = 1,
	PreServer_Select = 5,
	Server_Select = 7,
	Character_Select = 8,
	Character_Creation = 9,
	SetCustomize_CharacterPos = 11,
	In_Game = 12
};

class World {
public:
	static int GetCurrentStage();
	static int GetCurrentTransition();
	static const char* GetCurrentStageStr();
};

class Interaction {
public:
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
	static IActor* get_closest_monster_filtered(float maxRange, std::vector<std::string> whitelist, std::vector<std::string> blacklist);
	static IActor* get_closest_player(float maxRange);
	static IActor* get_closest_lootable(float maxRange);

	static bool is_player_nearby(float maxRange);
	static bool is_targetable(uint32_t targetId);

	//static uint32_t get_current_target_id();
	static uint32_t get_closest_mob_targetid(float maxRange);
	static uint32_t get_closest_target_with_type(uint32_t TargetType, float maxRange);
	static uint32_t get_closest_targetId_with_name(char * TargetName, float maxRange);

	static std::vector<IActor*> get_aggro_mob_list();
	static std::vector<IActor*> get_unique_mob_list();

	static void* get_unit_by_id(uint32_t targetId);
	static uint32_t get_current_target_id();

	static BOOL set_current_target(uint32_t targetId);
	static BOOL cast_skill_on_targetId(uint32_t TargetId, uint32_t SkillId);
	static BOOL cast_skill_on_current_target(uint32_t SkillId);
	static BOOL cast_skill_on_self(uint32_t SkillId);

	static BOOL isRunning();
	static BOOL is_casting();
	static BOOL is_channeling();
	static BOOL is_in_combat();
	static BOOL is_dead(uint32_t unitID);
	static BOOL is_targeting_me(uint32_t unitID);

	static BOOL stop_casting();
	static BOOL stop_channeling();
};

class Loot {
public:
	static BOOL is_lootable(DWORD unitId);
	static BOOL loot_all();
};


class Stealth {
	static BOOL is_player_nearby(float range);
	static BOOL escape_from_player();
};
