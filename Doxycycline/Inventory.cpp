#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "Inventory.h"



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

ItemInfo * Inventory::get_bag_item_information(uint32_t slot)
{
	uint32_t slotIdx = get_item_slotIdx(slot, 0x200);

	UINT_PTR* SlotClass = X2::W_GetSlotClass();

	ItemInfo* itemInfo = (ItemInfo*)X2::W_GetItemInformation(SlotClass, slotIdx);

	return itemInfo;
}

ItemInfoEx * Inventory::get_bag_item_informationEX(uint32_t slot)
{
	return &ItemInfoEx();
}

uint32_t Inventory::get_item_slotIdx(uint32_t slot, uint32_t idx)
{
	uint32_t slotIdx = 0;
	uint32_t tempSlot = (slot - 1) * 0x1000000;
	slotIdx = slotIdx | idx | tempSlot;

	return slotIdx;
}

uint32_t Inventory::get_count_by_itemId(uint32_t itemId)
{
	UINT_PTR* BagClass = X2::W_GetBagClass();

	if (!BagClass)
		return 0;

	uint32_t UsedSlots = X2::W_GetItemIdCount(BagClass, 45505);
	return UsedSlots;
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
	
	printf("maxbank: %d\n", maxBankSlot);

	uint8_t emptySlotCount = 0;

	for (int i = 1; i < maxBankSlot + 1; i++)
	{
		ItemInfo* info = get_bag_item_information(i);
		if (info)
		{
			if(info->ItemId == 0)
				emptySlotCount++;
		}
	}

	return emptySlotCount;
}
