#include "pch.h"
#include "GameClasses.h"
#include "Game.h"
#include "Skills.h"
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


const char* Inventory::get_usage_string(int usage)
{
	const char* result;

	switch (usage)
	{
	case 1:
		result = "carry";
		break;
	case 2:
		result = "equip";
		break;
	case 3:
		result = "consume";
		break;
	case 4:
		result = "toggle";
		break;
	case 5:
		result = "place";
		break;
	case 6:
		result = "socket";
		break;
	case 7:
		result = "spawn";
		break;
	case 8:
		result = "build";
		break;
	default:
		result = "invalid item_usage";
		break;
	}
	return result;
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

const char* Inventory::get_item_category_string(uint32_t slot)
{
	auto infoExtra = get_bag_infoExtra(slot);

	if (!infoExtra)
		return 0;

	return infoExtra->category;
}

CItem Inventory::get_item_master_info(uint32_t slot)
{
	auto info = get_bag_item_information(slot);

	if(!info)
		return CItem();

	auto infoEx = get_bag_item_informationEX(slot);

	if (!infoEx)
		return CItem();

	auto infoExtra = get_bag_infoExtra(slot);

	if (!infoExtra)
		return CItem();

	CItem skillMasterInfo;

	skillMasterInfo.Name = infoEx->Name;
	skillMasterInfo.slot = slot;
	skillMasterInfo.currentStack = info->Stack;
	skillMasterInfo.isConsumable = is_item_consumable(slot);
	skillMasterInfo.isSellable = is_item_sellable(slot);
	skillMasterInfo.isUnidentified = is_item_unidentified(slot);
	skillMasterInfo.itemId = infoEx->ItemId;
	skillMasterInfo.levelRequirement = infoEx->levelRequirement;
	skillMasterInfo.MaxStack = infoEx->MaxStack;
	skillMasterInfo.skillType = infoEx->skillType;
	skillMasterInfo.soulBoundEnum = infoEx->SoulBoundEnum;
	skillMasterInfo.usageEnum = infoExtra->usageEnum;

	return skillMasterInfo;
}

std::vector<uint32_t> Inventory::get_all_bag_items()
{
	std::vector<uint32_t> bag_items;

	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return std::vector<uint32_t>(); // Empty Vector

	for (int i = 1; i < maxSlot; ++i)
	{
		auto info = get_bag_item_information(i);

		if (!info)
			continue;

		bag_items.push_back(info->ItemId);
	}

	return bag_items;
}

std::vector<uint32_t> Inventory::get_all_consumeable_item()
{
	std::vector<uint32_t> consumeable_item_list;

	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return std::vector<uint32_t>(); // Empty Vector

	for (int i = 1; i < maxSlot; ++i)
	{
		if (is_item_consumable(i))
		{
			auto info = get_bag_item_information(i);
			
			if (!info)
				continue;

			consumeable_item_list.push_back(info->ItemId);
		}
	}

	return consumeable_item_list;
}

std::vector<uint32_t> Inventory::get_all_unidentified_item()
{
	std::vector<uint32_t> consumeable_item_list;
	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return std::vector<uint32_t>(); // Empty Vector

	for (int i = 1; i < maxSlot; ++i)
	{
		if (is_item_unidentified(i))
		{
			auto info = get_bag_item_information(i);

			if (!info)
				continue;

			consumeable_item_list.push_back(info->ItemId);
		}
	}

	return consumeable_item_list;
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
	auto infoExtra = get_bag_infoExtra(slot);

	if (!infoExtra)
		return false;

	return infoExtra->usageEnum == 3;
}

bool Inventory::is_item_unidentified(uint32_t slot)
{
	auto infoExtra = get_bag_infoExtra(slot);

	if (!infoExtra)
		return false;

	return iequals("unidentified", infoExtra->category);
}

bool Inventory::is_item_sellable(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return false;

	return ((itemEx->bSellable >> 3) & 1);
}

bool Inventory::is_item_stackable(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return false;

	return (itemEx->MaxStack > 1);
}

bool Inventory::is_item_off_cooldown(uint32_t slot)
{
	auto itemEx = get_bag_item_informationEX(slot);

	if (!itemEx)
		return false;

	return Skill::get_skill_cooldown(itemEx->skillType) == 0;
}

bool Inventory::move_item_to_bag(uint32_t bankSlot)
{
	uint32_t slotIdx = get_item_slotIdx(bankSlot, 0x300);

	if (!slotIdx)
		return false;

	return X2::W_MoveItemToEmptyBagSlot(slotIdx);
}

bool Inventory::move_item_to_bank(uint32_t bagSlot)
{
	uint32_t slotIdx = get_item_slotIdx(bagSlot, 0x200);

	if (!slotIdx)
		return false;

	return X2::W_MoveItemToEmptyBankSlot(slotIdx);
}


// Fix this, it is bad
void Inventory::move_partial_item(uint32_t Slot, uint32_t Quantity, bool from_bank)
{
	UINT_PTR* storageClass = NULL;
	ItemInfo* itemInfo = NULL;
	uint32_t slotIdx = 0;


	if (from_bank)
	{
		slotIdx = get_item_slotIdx(Slot, 0x300);
		itemInfo = get_bank_item_information(Slot);
	}
	else
	{
		slotIdx = get_item_slotIdx(Slot, 0x200);
		itemInfo = get_bag_item_information(Slot);
	}

	return X2::W_MoveItemPartial((UINT_PTR*)itemInfo, slotIdx, Quantity);
}

void Inventory::withdraw_money_from_bank(uint32_t Count)
{
	return X2::W_WithdrawMoney(Count, 0);
}

void Inventory::deposit_money_to_bank(uint32_t Count)
{
	return X2::W_DepositMoney(Count, 0);
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

InfoExtra* Inventory::get_bag_infoExtra(uint32_t slot)
{
	auto infoEx = get_bag_item_informationEX(slot);

	if (!infoEx)
		return NULL;

	InfoExtra* infoExtra = (InfoExtra*)X2::W_GetItemInfoExtra(infoEx->extraInfo);

	if (!infoExtra)
		return NULL;

	return infoExtra;
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

uint32_t Inventory::find_bag_item_slot_by_itemId(uint32_t itemId)
{
	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return 0;

	for (int i = 1; i < maxSlot; ++i)
	{
		ItemInfo* info = get_bag_item_information(i);

		if (info)
		{
			if (itemId == info->ItemId)
				return i;
		}
	}

	return 0;
}

uint32_t Inventory::find_bag_item_slot_by_name(const char* itemName)
{
	uint8_t maxSlot = get_max_bag_slot_count();

	if (!maxSlot)
		return 0;

	for (int i = 1; i < maxSlot; ++i)
	{
		ItemInfoEx* info = get_bag_item_informationEX(i);

		if (info)
		{
			if (iequals(itemName, info->Name))
				return i;
		}
	}

	return 0;
}

uint32_t Inventory::find_bank_item_slot_by_itemId(uint32_t itemId)
{
	uint8_t maxSlot = get_max_bank_slot_count();

	if (!maxSlot)
		return 0;

	for (int i = 1; i < maxSlot; ++i)
	{
		ItemInfo* infoEx = get_bank_item_information(i);

		if (infoEx)
		{
			if (itemId == infoEx->ItemId)
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

	uint32_t UsedSlots = X2::W_GetItemIdCount(BagClass, itemId);
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
