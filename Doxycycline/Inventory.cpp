#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "Inventory.h"

bool iequals(const std::string& a, const std::string& b)
{
	return std::equal(a.begin(), a.end(),
		b.begin(), b.end(),
		[](char a, char b) {
		return tolower(a) == tolower(b);
	});
}

const char* get_process_stateStr(int processedState)
{
	int v1;
	int v2;

	v1 = processedState - 1;
	if (!v1)
		return "raw_material";
	v2 = v1 - 1;
	if (!v2)
		return "semi_finished_material";
	if (v2 == 1)
		return "finished_product";
	return "invalid item_processed_state";
}

const char* Inventory::get_soul_bound_string(int soulbound)
{
	switch (soulbound)
	{
	case 1:
		return "normal";
		break;
	case 2:
		return "soulbound_pickup";
		break;
	case 3:
		return "soulbound_equip";
		break;
	case 4:
		return "soulbound_unpack";
		break;
	case 5:
		return "soulbound_pickup_pack";
		break;
	case 6:
		return "soulbound_pickup_auction_win";
		break;
	default:
		return "invalid item_bind_type";
		break;
	}
}

const char* Inventory::get_item_usage(int itemUsage)
{
	switch (itemUsage)
	{
	case 1:
		return "carry";
		break;
	case 2:
		return "equip";
		break;
	case 3:
		return "consume";
		break;
	case 4:
		return "toggle";
		break;
	case 5:
		return "place";
		break;
	case 6:
		return "socket";
		break;
	case 7:
		return "spawn";
		break;
	case 8:
		return "build";
		break;
	default:
		return "invalid item_usage";
		break;
	}
}

bool Inventory::is_bank_full()
{
	if (empty_bank_slot_count() == 0)
		return true;
	else
		return false;
}

bool Inventory::is_bag_full()
{
	if (empty_bag_slot_count() == 0)
		return true;
	else
		return false;
}

bool Inventory::is_item_consumable(uint32_t slot)
{
	return false;
}

bool Inventory::is_item_sellable(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return false;

	return ((itemEx->bSellable >> 3) & 1);
}

bool Inventory::is_item_tradeable(uint32_t slot)
{
	return false;
}

bool Inventory::is_item_stackable(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return false;

	return (itemEx->MaxStack > 1);
}

bool Inventory::is_item_usable(uint32_t slot)
{
	return false;
}

ItemInfo * Inventory::get_bag_item_information(uint32_t slot)
{
	uint32_t slotIdx = get_item_slotIdx(slot, 0x200);

	UINT_PTR* SlotClass = X2::W_GetSlotClass();

	ItemInfo* itemInfo = (ItemInfo*)X2::W_GetItemInformation(SlotClass, slotIdx);

	return itemInfo;
}

ItemInfo* Inventory::get_bank_item_information(uint32_t slot)
{
	uint32_t slotIdx = get_item_slotIdx(slot, 0x300);

	UINT_PTR* bankClass = X2::W_GetBankClass();

	ItemInfo* itemInfo = (ItemInfo*)X2::W_GetItemInformation(bankClass, slotIdx);

	return itemInfo;
}

ItemInfoEx * Inventory::get_bag_item_informationEX(uint32_t slot)
{
	ItemInfo* itemInfo = get_bag_item_information(slot);

	if (!itemInfo)
		return NULL;

	ItemInfoEx* itemInfoEx = (ItemInfoEx*)X2::W_GetItemInformationEx(*(DWORD*)((UINT_PTR)itemInfo + 8));

	return itemInfoEx;
}

ItemInfoEx* Inventory::get_bank_item_informationEX(uint32_t slot)
{
	ItemInfo * itemInfo = get_bank_item_information(slot);

	if (!itemInfo)
		return NULL;

	ItemInfoEx* itemInfoEx = (ItemInfoEx*)X2::W_GetItemInformationEx(*(DWORD*)((UINT_PTR)itemInfo + 8));

	return itemInfoEx;
}

// Slot Idx is for that weird shit with LODWORD and HIDWORD
uint32_t Inventory::get_item_slotIdx(uint32_t slot, uint32_t idx)
{
	uint32_t slotIdx = 0;
	uint32_t tempSlot = (slot - 1) * 0x1000000;
	slotIdx = slotIdx | idx | tempSlot;

	return slotIdx;
}

uint32_t Inventory::find_bag_item_slot_by_name(const char* itemName)
{
	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return 0;

	for (int i = 1; i < maxSlot; ++i)
	{
		ItemInfoEx* infoEx = get_bag_item_informationEX(i);

		if (infoEx)
		{
			if (iequals(itemName, infoEx->Name))
				return i;
		}
	}

	return 0;
}

uint32_t Inventory::find_bank_item_slot_by_name(const char* itemName)
{
	uint8_t maxSlot = get_max_bank_slot_count();

	if (!maxSlot)
		return 0;

	for (int i = 1; i < maxSlot; ++i)
	{
		ItemInfoEx* infoEx = get_bank_item_informationEX(i);

		if (infoEx)
		{
			if (iequals(itemName, infoEx->Name))
				return i;
		}
	}

	return 0;
}


uint32_t Inventory::get_item_max_stack(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return 0;

	return itemEx->MaxStack;
}

uint32_t Inventory::get_item_current_stack(uint32_t slot)
{
	auto item = get_bag_item_information(slot);

	if (!item)
		return 0;

	return item->Stack;
}

uint32_t Inventory::get_count_by_itemId(uint32_t itemId)
{
	UINT_PTR* BagClass = X2::W_GetBagClass();

	if (!BagClass)
		return 0;

	uint32_t UsedSlots = X2::W_GetItemIdCount(BagClass, 45505);
	return UsedSlots;
}

uint8_t Inventory::get_current_bag_slot_count()
{
	uint8_t current_bag_count = get_max_bag_slot_count() - empty_bag_slot_count();

	return current_bag_count;
}

uint8_t Inventory::get_current_bank_slot_count()
{
	uint8_t current_bank_count = get_max_bank_slot_count() - empty_bank_slot_count();

	return current_bank_count;
}

uint8_t Inventory::get_max_bag_slot_count()
{
	UINT_PTR* SlotClass = X2::W_GetSlotClass();

	if (!SlotClass)
		return 0;

	return *(BYTE*)((UINT_PTR)SlotClass + 9);
}

uint8_t Inventory::get_max_bank_slot_count()
{
	UINT_PTR* BankClass = X2::W_GetBankClass();

	if (!BankClass)
		return 0;

	return *(BYTE*)((UINT_PTR)BankClass + 9);
}

uint8_t Inventory::empty_bag_slot_count()
{
	UINT_PTR* SlotClass = X2::W_GetBagClass();

	if (!SlotClass)
		return 0;

	return X2::W_GetEmptySlotCount(SlotClass);
}

uint8_t Inventory::empty_bank_slot_count()
{
	uint8_t maxBankSlot = get_max_bank_slot_count();

	if (!maxBankSlot)
		return 0;
	
	uint8_t emptySlotCount = 0;

	for (int i = 1; i < maxBankSlot; ++i)
	{
		ItemInfo* info = get_bank_item_information(i);

		if (!info || info->ItemId == 0)
			emptySlotCount++;
	}

	return emptySlotCount;
}

bool Inventory::use_item_by_slot(uint32_t slot)
{
	auto item = get_bag_item_information(slot);

	if (!item || item->ItemId == 0)
		return false;

	return X2::W_UseItemById(item->ItemId);
}

bool Inventory::use_item_by_itemId(uint32_t itemId)
{
	return X2::W_UseItemById(itemId);
}
