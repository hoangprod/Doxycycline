#pragma once

class ItemInfoEx
{
public:
	uint32_t ItemId; //0x0000
	char pad_0004[44]; //0x0004
	char* Description; //0x0030
	char pad_0038[72]; //0x0038
	uint32_t MaxStack; //0x0080
	char pad_0084[4]; //0x0084
	char* Name; //0x0088
	char pad_0090[361]; //0x0090
	uint8_t bSellable; //0x01F9
	char pad_01FA[593]; //0x01FA
}; //Size: 0x044B

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
	static ItemInfoEx* get_bag_item_informationEX(uint32_t slot);
	static ItemInfoEx* get_bank_item_informationEX(uint32_t slot);
	static uint32_t get_item_slotIdx(uint32_t slot, uint32_t idx);

	static uint32_t find_bag_item_slot_by_name(char* itemName);
	static uint32_t find_bank_item_slot_by_name(char* itemName);

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
	static bool is_item_sellable(uint32_t slot);
	static bool is_item_tradeable(uint32_t slot);
	static bool is_item_stackable(uint32_t slot);
	static bool is_item_usable(uint32_t slot);
	static bool is_item_off_cooldown(uint32_t slot);

	static bool move_item_to_bag(uint32_t bankSlot);
	static bool move_item_to_bank(uint32_t bagSlot);
	static bool move_partial_item(uint32_t Slot, uint32_t Quantity);
	static bool withdraw_money_from_bank(uint32_t Count);
	static bool deposit_money_to_bank(uint32_t Count);


	static bool sell_to_npc(DWORD npcId, DWORD slot);
	static bool buy_from_npc(DWORD npcId, DWORD itemId);

	static const char* get_soul_bound_string(int soulbound);
	static const char* get_item_usage(int itemUsage);
	static const char* get_item_category(uint32_t slot);
};

