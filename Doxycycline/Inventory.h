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
	static DWORD find_item_slot_by_name(char* itemName);

	static BOOL use_item(DWORD slotId);
	static BOOL move_item(DWORD from_slot, DWORD to_slot);
	static BOOL move_to_bank(DWORD slotId);
	static BOOL withdraw_from_bank(DWORD slotId);
	static BOOL sell_to_npc(DWORD npcId, DWORD slot);
	static BOOL buy_from_npc(DWORD npcId, DWORD itemId);
};