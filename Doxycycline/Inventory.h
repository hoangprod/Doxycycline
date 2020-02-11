#pragma once

class ItemInfoEx
{
public:
	uint32_t ItemId; //0x0000
	int32_t actabilityGroup; //0x0004
	int32_t actabilityRequirement; //0x0008
	char pad_000C[8]; //0x000C
	uint8_t SoulBoundEnum; //0x0014
	char pad_0015[7]; //0x0015
	uint32_t extraInfo; //0x001C
	char pad_0020[4]; //0x0020
	uint32_t contributionPointPrice; //0x0024
	uint32_t craftType; //0x0028
	char pad_002C[4]; //0x002C
	char* Description; //0x0030
	char pad_0038[8]; //0x0038
	uint64_t hasTime; //0x0040
	char pad_0048[8]; //0x0048
	uint8_t fixedGrade; //0x0050
	char pad_0051[3]; //0x0051
	uint32_t honorPrice; //0x0054
	char pad_0058[4]; //0x0058
	int32_t item_impl; //0x005C
	uint32_t N000007CF; //0x0060
	uint32_t levelLimit; //0x0064
	uint32_t levelRequirement; //0x0068
	char pad_006C[4]; //0x006C
	uint32_t livingPointPrice; //0x0070
	char pad_0074[12]; //0x0074
	uint32_t MaxStack; //0x0080
	char pad_0084[4]; //0x0084
	char* Name; //0x0088
	char pad_0090[64]; //0x0090
	uint32_t skillType; //0x00D0
	char pad_00D4[293]; //0x00D4
	uint8_t bSellable; //0x01F9
	char pad_01FA[14]; //0x01FA
}; //Size: 0x0208

class InfoExtra
{
public:
	char pad_0000[16]; //0x0000
	char* category; //0x0010
	uint32_t materialEnum; //0x0018
	uint32_t usageEnum; //0x001C
}; //Size: 0x0020

class ItemInfo
{
public:
	char pad_0000[8]; //0x0000
	int32_t ItemId; //0x0008
	char pad_000C[1]; //0x000C
	uint8_t SoulBoundEnum; //0x000D
	char pad_000E[2]; //0x000E
	uint32_t Stack; //0x0010
	char pad_0014[154]; //0x0014
}; //Size: 0x00AE


class Inventory {
public:
	static ItemInfo* get_bag_item_information(uint32_t slot);
	static ItemInfo* get_bank_item_information(uint32_t slot);
	static InfoExtra* get_bag_infoExtra(uint32_t slot);
	static ItemInfoEx* get_bag_item_informationEX(uint32_t slot);
	static ItemInfoEx* get_bank_item_informationEX(uint32_t slot);
	static uint32_t get_item_slotIdx(uint32_t slot, uint32_t idx);

	static uint32_t find_bag_item_slot_by_itemId(uint32_t itemId);
	static uint32_t find_bag_item_slot_by_name(const char* itemName);
	static uint32_t find_bank_item_slot_by_itemId(uint32_t itemId);
	static uint32_t find_bank_item_slot_by_name(const char* itemName);

	static uint32_t get_current_bag_money();
	static uint32_t get_current_bank_money();

	static uint32_t get_item_max_stack(uint32_t slot);
	static uint32_t get_item_current_stack(uint32_t slot);

	static uint32_t get_count_by_itemId(uint32_t itemId);
	static uint8_t get_current_bag_slot_count();
	static uint8_t get_current_bank_slot_count();
	static uint8_t get_max_bag_slot_count();
	static uint8_t get_max_bank_slot_count();
	static uint8_t empty_bag_slot_count();
	static uint8_t empty_bank_slot_count();

	static bool use_item_by_slot(uint32_t slot);
	static bool use_item_by_itemId(uint32_t itemId);

	static bool is_bank_full();
	static bool is_bag_full();

	static bool is_item_consumable(uint32_t slot);
	static bool is_item_unidentified(uint32_t slot);
	static bool is_item_sellable(uint32_t slot);
	static bool is_item_tradeable(uint32_t slot);
	static bool is_item_stackable(uint32_t slot);
	static bool is_item_off_cooldown(uint32_t slot);

	static bool move_item_to_bag(uint32_t bankSlot);
	static bool move_item_to_bank(uint32_t bagSlot);
	static void withdraw_money_from_bank(uint32_t Count);
	static void deposit_money_to_bank(uint32_t Count);

	static void move_partial_item(uint32_t Slot, uint32_t Quantity, bool from_bank);

	static bool sell_to_npc(DWORD npcId, DWORD slot);
	static bool buy_from_npc(DWORD npcId, DWORD itemId);

	static const char* get_usage_string(int usage);
	static const char* get_soul_bound_string(int soulbound);
	static const char* get_item_category_string(uint32_t slot);

	static CItem get_item_master_info(uint32_t slot);

	// These store ItemID not Slot so when items are moved around -- it won't affect us
	static std::vector<uint32_t> get_all_bag_items();
	static std::vector<uint32_t> get_all_consumeable_item();
	static std::vector<uint32_t> get_all_unidentified_item();
};

bool iequals(const std::string& a, const std::string& b);