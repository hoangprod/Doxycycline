#include "pch.h"
#include "Imgui/examples/imgui_memory_editor.h"
#include "GameClasses.h"
#include "Hacks.h"
#include "LuaAPI.h"
#include "Radar.h"
#include "Helper.h"
#include "Skills.h"
#include "Combat.h"
#include "Inventory.h"
#include "json.hpp"
#include "Menu.h"
#include <iomanip>

using json = nlohmann::json;

MemoryEditor mem_edit;
Consolelogs console;
PacketEditor peditor;
HackView hackView;
Radar radar;

const char* Data = "PlaceholderData";
ImU64* Address = (ImU64*)Data;
ImU32 Size = 15;
const ImU64 iStep = 1;

static const char* lua_items[] = { "Lua State 1", "Lua State 2", "Lua State 3" };
static const char* current_lua_item = lua_items[0];

packetCrypto packetinfo;
Settings settings;

bool b_displayLocalPlayerInfo = false;
bool b_Console = true, b_MemoryEditor = false, b_PacketEditor = false, b_Radar = false, b_LuaMenu = true, b_GrindMenu = true;

void* LuaStateRun = 0;

typedef bool(__fastcall* f_EncryptPacket)(__int64* buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer);
typedef UINT_PTR(__fastcall* f_EncryptSendPacket)(UINT_PTR localPlayer, UINT_PTR packetBody);

extern bool g_HijackCtrl;
extern f_EncryptPacket o_EncryptPacket;
extern f_EncryptSendPacket o_Encrypt_Send;
extern Addr Patterns;
void PacketEditor::Replay(std::vector<char*> pVector, BYTE Element)
{
	o_Encrypt_Send( *(UINT_PTR*)Patterns.Addr_UnitClass,(__int64)pVector[Element]);
}

void MenuRender()
{
	hackView.Display();

	if (b_LuaMenu)
		hackView.LuaScript();

	if(b_Console)
		console.Draw("Console Logs", &b_Console);

	if (b_MemoryEditor)
		hackView.DisplayMemEdit();

	if(b_PacketEditor)
		peditor.Display();

	if(b_Radar)
		radar.Render();

	if (b_GrindMenu)
		Grinder::Display();

}

void HackView::LuaScript()
{
	ImGui::Begin("Lua Executor");

	ImGui::BeginCombo("", current_lua_item);
	for (int i = 0; i < IM_ARRAYSIZE(lua_items); i++)
	{
		bool is_selected = (current_lua_item == lua_items[i]);
		if (ImGui::Selectable(lua_items[i], is_selected))
			current_lua_item = lua_items[i];
	}

	if (ImGui::Button("Execute Lua Script"))
	{
		void* currentLuaState;
		if (current_lua_item == lua_items[0])
			LuaStateRun = currentLuaState = SSystemGlobalEnvironment::GetInstance()->pScriptSysOne->luaState;
		if (current_lua_item == lua_items[1])
			LuaStateRun = currentLuaState = SSystemGlobalEnvironment::GetInstance()->pScriptSysTwo->luaState;
		if (current_lua_item == lua_items[2])
			LuaStateRun = currentLuaState = SSystemGlobalEnvironment::GetInstance()->pScriptSysThree->luaState;

		//lua_c_ExecuteLuaFile(currentLuaState, "script.lua");
	}

	ImGui::End();
}

void HackView::DisplayMemEdit()
{
	ImGui::Begin("Memory Editor");
	ImGui::InputScalar(" Address", ImGuiDataType_S64, &Address, &iStep, NULL, "%016X", ImGuiInputTextFlags_CharsHexadecimal);
	ImGui::InputScalar(" Size", ImGuiDataType_U32, &Size, &iStep, NULL, "%x");
	mem_edit.DrawContents(Address, Size);
	ImGui::End();
}

void HackView::Display()
{
	ImGui::Begin("Hacks");

	ImGui::Checkbox("Fly Hack", &bFlyHack); ImGui::SameLine();
	if (ImGui::Checkbox("No Fall Damage", &bNoFallDamage))
	{
		ToggleNoFall(bNoFallDamage);
	}


	ImGui::Checkbox("Memory Editor", &b_MemoryEditor); ImGui::SameLine();
	ImGui::Checkbox("Log Console", &b_Console); ImGui::SameLine();
	ImGui::Checkbox("Grind Bot", &b_GrindMenu); ImGui::SameLine();
	ImGui::Checkbox("Lua Executor", &b_LuaMenu); ImGui::SameLine();
	ImGui::Checkbox("Radar", &b_Radar); ImGui::SameLine();
	ImGui::Checkbox("Packet Editor", &b_PacketEditor);

	if (ImGui::SliderFloat("Player Speed", &speedMultiplier, 1.0f, 50.0f))
	{
		SetPlayerStatSpeed(speedMultiplier);
	}

	if (ImGui::SliderFloat("Player Animation Speed", &animationMultiplier, 1.0f, 50.0f))
	{
		SetPlayerAnimationSpeed(animationMultiplier);
	}

	ImGui::InputFloat("Path X", &pathPosition_DoNotModify.x);
	ImGui::InputFloat("Path Y", &pathPosition_DoNotModify.y);
	ImGui::InputFloat("Path Z", &pathPosition_DoNotModify.z);
	if (ImGui::Button("Go to path"))
	{
		Navigation::move_to_position(pathPosition_DoNotModify);
	}

	ImGui::SameLine();

	ImGui::Checkbox("Display local player debug info", &b_displayLocalPlayerInfo);

	if (b_displayLocalPlayerInfo)
	{
		if (LocalPlayerFinder::GetClientActorId())
		{
			IEntity* localEnt = LocalPlayerFinder::GetClientEntity();
			void* localActor = LocalPlayerFinder::GetClientActor();
			if (localEnt)
			{
				std::stringstream idStrm;
				std::stringstream entAddressStrm;
				std::stringstream actorAddressStrm;
				std::stringstream positionStrm;
				std::stringstream angleStrm;
				std::stringstream rotationStrm;

				idStrm << "Local Actor and Entity ID: 0x" << std::hex << LocalPlayerFinder::GetClientActorId() << std::endl;
				ImGui::Text(idStrm.str().c_str());

				actorAddressStrm << "Local Actor: 0x" << localActor;
				ImGui::Text(actorAddressStrm.str().c_str());

				entAddressStrm << "Local Entity: 0x" << localEnt;
				ImGui::Text(entAddressStrm.str().c_str());

				Vec3 pos = localEnt->GetWorldPos();
				positionStrm << "Your position - X: " << pos.x << ", Y: " << pos.y << ", Z: " << pos.z;
				ImGui::Text(positionStrm.str().c_str());

				Vec3 angles = localEnt->GetFixedAngles();
				angleStrm << "Your angles - X: " << angles.x << ", Y: " << angles.y << ", Z: " << angles.z;
				ImGui::Text(angleStrm.str().c_str());

				Quat rotation = localEnt->GetRotation();
				rotationStrm << "Your rotation - X: " << rotation.v.x << ", Y: " << rotation.v.y << ", Z: " << rotation.v.z << ", W: " << rotation.w;
				ImGui::Text(rotationStrm.str().c_str());
			}
		}
	}

	ImGui::EndCombo();

	ImGui::End();
}

void PacketEditor::Display()
{
	ImGui::Begin("Packet Editor");
	ImGui::Checkbox("Log Packets", &toLogPacket);
	ImGui::SameLine();
	if (ImGui::Button("Clear"))
	{
		Clear();
	}

	ImGui::Separator();
	ImGui::Columns(2);
	BYTE element = 0;
	for (auto i : PacketsArr) {
		ImGui::Text("[%d] - Opcode: %02X %02X", element, *(BYTE*)(i + 8), *(BYTE*)(i + 9)); ImGui::SameLine();

		char* buttonID = (char*)"Replay##";
		char* buttonID2 = (char*)"Save##";
		char* buttonID3 = (char*)"Edit##";
		char* buttonID4 = (char*)"Copy##";

		std::stringstream ss, sss, ssss, sssss;

		ss << buttonID << element;
		sss << buttonID2 << element;
		ssss << buttonID3 << element;
		sssss << buttonID4 << element;

		if (ImGui::Button(ss.str().c_str()))
		{
			this->Replay(PacketsArr, element);
		}
		ImGui::SameLine();
		if (ImGui::Button(ssss.str().c_str()))
		{
			this->Edit(PacketsArr, element);
		}
		ImGui::SameLine();
		if (ImGui::Button(sss.str().c_str()))
		{
			SavedPackets.push_back(i);
		}
		ImGui::SameLine();
		if (ImGui::Button(sssss.str().c_str()))
		{
			this->CopyClipboard(PacketsArr, element);
		}
		element++;
	}
	ImGui::NextColumn();
	BYTE element2 = 0;
	for (auto i : SavedPackets) {
		ImGui::Text("[%d] - Opcode: %02X %02X", element2, *(BYTE*)(i + 8), *(BYTE*)(i + 9)); ImGui::SameLine();

		std::string Replay = "Replay##" + std::to_string(element2);
		std::string Remove = "Remove##" + std::to_string(element2);
		std::string Edit = "Edit##" + std::to_string(element2);
		std::string Copy = "Copy##" + std::to_string(element2);


		if (ImGui::Button(Replay.c_str()))
		{
			this->Replay(SavedPackets, element2);
		}
		ImGui::SameLine();
		if (ImGui::Button(Remove.c_str()))
		{
			SavedPackets.erase(SavedPackets.begin() + element2);
		}
		ImGui::SameLine();
		if (ImGui::Button(Edit.c_str()))
		{
			this->Edit(SavedPackets, element2);
		}
		ImGui::SameLine();
		if (ImGui::Button(Copy.c_str()))
		{
			this->CopyClipboard(SavedPackets, element2);
		}
		element2++;
	}
	ImGui::NextColumn();
	ImGui::End();
}

void PacketEditor::Push(UINT_PTR pBody)
{
	if (toLogPacket) {
		if (PacketsArr.size() > 100) {
			Pop();
		}
		WORD pSize = 0x400;

		char* packet = new char[pSize];
		memcpy(packet, (void*)pBody, pSize);
		PacketsArr.push_back(packet);
	}
}


namespace ImGui
{
	template <typename T>
	std::string to_string_with_precision(const T a_value, const int n = 0)
	{
		std::ostringstream out;
		out.precision(n);
		out << std::fixed << a_value;
		return out.str();
	}

	static auto vector_getter = [](void* vec, int idx, const char** out_text)
	{
		auto& vector = *static_cast<std::vector<std::string>*>(vec);
		if (idx < 0 || idx >= static_cast<int>(vector.size())) { return false; }
		*out_text = vector.at(idx).c_str();
		return true;
	};

	bool Combo(const char* label, int* currIndex, std::vector<std::string>& values)
	{
		if (values.empty()) { return false; }
		return Combo(label, currIndex, vector_getter,
			static_cast<void*>(&values), values.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<uint32_t>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (std::vector<uint32_t>::iterator it = values.begin(); it != values.end(); ++it) {
			uint32_t slot = Inventory::find_bag_item_slot_by_itemId(*it);

			if (!slot)
				continue;

			ItemInfoEx* itemInfoEx = Inventory::get_bag_item_informationEX(slot);

			if (!itemInfoEx)
				continue;
			
			strValue.push_back("Slot: " + std::to_string(slot) + " | Name: " + std::string(itemInfoEx->Name));

		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<Vec3>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (std::vector<Vec3>::iterator it = values.begin(); it != values.end(); ++it) {
			strValue.push_back(it->Str());
		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<IActor*>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (auto& element : values) {
			strValue.push_back(std::string(element->Entity->GetName()));
		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<ISkill*>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (auto& element : values) {
			std::pair<float, float> minmaxRange = Skill::get_skill_min_max_range(element->SkillId);
			std::string str = std::to_string(element->SkillId) + std::string(" Name: [") + std::string(element->Name) + std::string("] range: " +
				to_string_with_precision(minmaxRange.first) + "-" + to_string_with_precision(minmaxRange.second) + "m");
			strValue.push_back(str);
		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<Vertexes>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (std::vector<Vertexes>::iterator it = values.begin(); it != values.end(); ++it) {
			strValue.push_back(it->getString());
		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

	bool ListBox(const char* label, int* currIndex, std::vector<std::string>& values)
	{
		if (values.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&values), values.size());
	}
	bool ListBox(const char* label, int* currIndex, std::vector<std::pair<std::string, Vertexes>>& values)
	{
		if (values.empty()) { return false; }
		std::vector<std::string> strValue;
		for (std::vector<std::pair<std::string, Vertexes>>::iterator it = values.begin(); it != values.end(); ++it) {
			strValue.push_back(it->second.getString() + "    @ " + it->first);
		}
		if (strValue.empty()) { return false; }
		return ListBox(label, currIndex, vector_getter,
			static_cast<void*>(&strValue), strValue.size());
	}

}


namespace ns {
	void to_json(json& j, std::vector<Vec3>& p) {
		for (std::vector<Vec3>::iterator it = p.begin(); it != p.end(); ++it) {
			j[it - p.begin()] = (json{ { "x", it->x },{ "z", it->z },{ "y", it->y } });
		}
	}


	std::vector<Vec3> from_json(const json& j) {
		std::vector<Vec3> tempVector;
		for (auto it = j.begin(); it != j.end(); ++it) {
			Vec3 temp;
			temp.x = it->at("x").get<float>();
			temp.z = it->at("z").get<float>();
			temp.y = it->at("y").get<float>();
			tempVector.push_back(temp);
		}
		return tempVector;
	}
}

bool is_empty(std::ifstream& pFile)
{
	return pFile.peek() == std::ifstream::traits_type::eof();
}


void Grinder::Display()
{
	ImGui::Begin("GrindBot");

	// Toggles

	ImGui::Checkbox("Grinding On", &settings.grinding_bot_on); ImGui::SameLine();
	ImGui::Checkbox("Loot items", &settings.loot_items); ImGui::SameLine();
	ImGui::Checkbox("Player detection", &settings.hide_from_players); ImGui::SameLine();
	ImGui::Checkbox("Teleport2Mob", &settings.teleport_to_next_mob);

	ImGui::Checkbox("Deposit Items", &settings.deposit_items); ImGui::SameLine();
	ImGui::Checkbox("Send to Mule", &settings.send_to_mule); ImGui::SameLine();
	ImGui::Checkbox("Rotate path", &settings.go_back_to_beginning); ImGui::SameLine();
	ImGui::Checkbox("Resurrect", &settings.resurrect_after_death);

	// Sliders
	ImGui::SliderFloat("Wander Range", &settings.max_wander_range, 10.0f, 300.0f);
	ImGui::SliderFloat("Max Target Height", &settings.max_wander_range, 10.0f, 200.0f);
	ImGui::SliderFloat("Min. Health %", &settings.max_wander_range, 0.0f, 200.0f);
	ImGui::SliderFloat("Min. Mana %", &settings.min_mana_percentage, 0.0f, 100.0f);

	ImGui::Separator();

	static const char* listbox_combo[] = { "Wander Path", "Whitelist Mobs", "Blacklist Mobs", "Attack Spells", "Buff Spells", "Cleanse Spells", "Recover HP Spells", "Recover MP Spells", "Recover HP Items", "Recover MP Items", "Items to Open" };
	static int listBox_Selection = -1;
	ImGui::Combo("Configuration Menus", &listBox_Selection, listbox_combo, IM_ARRAYSIZE(listbox_combo));

	if (listBox_Selection == 0)
	{
		Vec3 CurrentPos = LocalPlayerFinder::GetClientEntity()->GetWorldPos();

		ImGui::Text("Current Position: %s", CurrentPos.Str().data());

		ImGui::ListBox("Wander Points", &settings.current_wander_path_selection, settings.wander_path_list);

		if (ImGui::Button("Add Wander Point")) {
			if (LocalPlayerFinder::GetClientEntity())
			{
				settings.wander_path_list.push_back(CurrentPos);
				++settings.current_wander_path_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove Point"))
		{
			if (!settings.wander_path_list.empty() && settings.current_wander_path_selection >= 0 && settings.current_wander_path_selection <= settings.wander_path_list.size() + 1)
			{
				settings.wander_path_list.erase(settings.wander_path_list.begin() + settings.current_wander_path_selection);
				--settings.current_wander_path_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List"))
		{
			settings.wander_path_list.clear();
		}
	}
	if (listBox_Selection == 1)
	{
		static int current_surround_mob_selection = -1;
		std::vector<IActor*> surroundMobs = Combat::get_unique_mob_list();
		ImGui::ListBox("Mobs in surrounding", &current_surround_mob_selection, surroundMobs);


		if (ImGui::Button("Add To Whitelist")) {
			if (!surroundMobs.empty() && current_surround_mob_selection >= 0 && current_surround_mob_selection <= surroundMobs.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.whitelist_monsters.push_back(surroundMobs[current_surround_mob_selection]->Entity->GetName());
					++settings.current_whitelist_mob_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove from Whitelist"))
		{
			if (!settings.whitelist_monsters.empty() && settings.current_whitelist_mob_selection >= 0 && settings.current_whitelist_mob_selection <= settings.whitelist_monsters.size() + 1)
			{
				settings.whitelist_monsters.erase(settings.whitelist_monsters.begin() + settings.current_whitelist_mob_selection);
				--settings.current_whitelist_mob_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List"))
		{
			settings.whitelist_monsters.clear();
		}

		ImGui::ListBox("Whitelist Mobs", &settings.current_whitelist_mob_selection, settings.whitelist_monsters);
	}
	if (listBox_Selection == 2)
	{
		static int current_surround_mob_selection = -1;
		std::vector<IActor*> surroundMobs = Combat::get_unique_mob_list();
		ImGui::ListBox("Mobs in surrounding", &current_surround_mob_selection, surroundMobs);


		if (ImGui::Button("Add To Blacklist")) {
			if (!surroundMobs.empty() && current_surround_mob_selection >= 0 && current_surround_mob_selection <= surroundMobs.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.blacklist_monsters.push_back(surroundMobs[current_surround_mob_selection]->Entity->GetName());
					++settings.current_blacklist_mob_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Blacklist"))
		{
			if (!settings.blacklist_monsters.empty() && settings.current_blacklist_mob_selection >= 0 && settings.current_blacklist_mob_selection <= settings.blacklist_monsters.size() + 1)
			{
				settings.blacklist_monsters.erase(settings.blacklist_monsters.begin() + settings.current_blacklist_mob_selection);
				--settings.current_blacklist_mob_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##1"))
		{
			settings.blacklist_monsters.clear();
		}

		ImGui::ListBox("Whitelist Mobs", &settings.current_blacklist_mob_selection, settings.blacklist_monsters);
	}
	if (listBox_Selection == 3)
	{
		static int current_search_skill = -1;
		static char str0[256];
		static std::vector<ISkill*> searchResult;
		ImGui::InputText("##SpellName", str0, IM_ARRAYSIZE(str0));
		
		ImGui::SameLine();

		if (ImGui::Button("Search Spell")) {
			searchResult = Skill::search_skill_id_by_name(str0);
		}

		if (ImGui::ListBox("Search Result", &current_search_skill, searchResult))
		{

		}

		if (ImGui::Button("Add To Attack Spell List")) {
			if (!searchResult.empty() && current_search_skill >= 0 && current_search_skill <= searchResult.size() + 1)
			{	
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.attack_spell_list.push_back(searchResult[current_search_skill]);
					++settings.current_attack_spell_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Attack Spell List"))
		{
			if (!settings.attack_spell_list.empty() && settings.current_attack_spell_selection >= 0 && settings.current_attack_spell_selection <= settings.attack_spell_list.size() + 1)
			{
				settings.attack_spell_list.erase(settings.attack_spell_list.begin() + settings.current_attack_spell_selection);
				--settings.current_attack_spell_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##2"))
		{
			settings.attack_spell_list.clear();
		}

		ImGui::ListBox("Attack Spell Order", &settings.current_attack_spell_selection, settings.attack_spell_list);
	}
	if (listBox_Selection == 4)
	{
		static int current_search_skill = -1;
		static char str0[256];
		static std::vector<ISkill*> searchResult;
		ImGui::InputText("##SpellName", str0, IM_ARRAYSIZE(str0));

		ImGui::SameLine();

		if (ImGui::Button("Search Spell")) {
			searchResult = Skill::search_skill_id_by_name(str0);
		}

		if (ImGui::ListBox("Search Result", &current_search_skill, searchResult))
		{

		}

		if (ImGui::Button("Add To Buff Spell List")) {
			if (!searchResult.empty() && current_search_skill >= 0 && current_search_skill <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.buff_spell_list.push_back(searchResult[current_search_skill]);
					++settings.current_buff_spell_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Buff Spell List"))
		{
			if (!settings.buff_spell_list.empty() && settings.current_buff_spell_selection >= 0 && settings.current_buff_spell_selection <= settings.buff_spell_list.size() + 1)
			{
				settings.buff_spell_list.erase(settings.buff_spell_list.begin() + settings.current_buff_spell_selection);
				--settings.current_buff_spell_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##3"))
		{
			settings.buff_spell_list.clear();
		}

		ImGui::ListBox("Buff Spells Priority", &settings.current_buff_spell_selection, settings.buff_spell_list);
	}
	if (listBox_Selection == 5)
	{
		static int current_search_skill = -1;
		static char str0[256];
		static std::vector<ISkill*> searchResult;
		ImGui::InputText("##SpellName", str0, IM_ARRAYSIZE(str0));

		ImGui::SameLine();

		if (ImGui::Button("Search Spell")) {
			searchResult = Skill::search_skill_id_by_name(str0);
		}

		if (ImGui::ListBox("Search Result", &current_search_skill, searchResult))
		{

		}

		if (ImGui::Button("Add To Cleanse Spell List")) {
			if (!searchResult.empty() && current_search_skill >= 0 && current_search_skill <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.cleanse_spell_list.push_back(searchResult[current_search_skill]);
					++settings.current_cleanse_spell_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Cleanse Spell List"))
		{
			if (!settings.cleanse_spell_list.empty() && settings.current_cleanse_spell_selection >= 0 && settings.current_cleanse_spell_selection <= settings.cleanse_spell_list.size() + 1)
			{
				settings.cleanse_spell_list.erase(settings.cleanse_spell_list.begin() + settings.current_cleanse_spell_selection);
				--settings.current_cleanse_spell_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##5"))
		{
			settings.cleanse_spell_list.clear();
		}

		ImGui::ListBox("Cleanse Spells Priority", &settings.current_cleanse_spell_selection, settings.cleanse_spell_list);
	}
	if (listBox_Selection == 6)
	{
		static int current_search_skill = -1;
		static char str0[256];
		static std::vector<ISkill*> searchResult;
		ImGui::InputText("##SpellName", str0, IM_ARRAYSIZE(str0));

		ImGui::SameLine();

		if (ImGui::Button("Search Spell")) {
			searchResult = Skill::search_skill_id_by_name(str0);
		}

		if (ImGui::ListBox("Search Result", &current_search_skill, searchResult))
		{

		}

		if (ImGui::Button("Add To Heal Spell List")) {
			if (!searchResult.empty() && current_search_skill >= 0 && current_search_skill <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.recover_hp_spell_list.push_back(searchResult[current_search_skill]);
					++settings.current_hp_heal_spell_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Heal Spell List"))
		{
			if (!settings.recover_hp_spell_list.empty() && settings.current_hp_heal_spell_selection >= 0 && settings.current_hp_heal_spell_selection <= settings.recover_hp_spell_list.size() + 1)
			{
				settings.recover_hp_spell_list.erase(settings.recover_hp_spell_list.begin() + settings.current_hp_heal_spell_selection);
				--settings.current_hp_heal_spell_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##6"))
		{
			settings.recover_hp_spell_list.clear();
		}

		ImGui::ListBox("Heal Spells Priority", &settings.current_hp_heal_spell_selection, settings.recover_hp_spell_list);
	}
	if (listBox_Selection == 7)
	{
		static int current_search_skill = -1;
		static char str0[256];
		static std::vector<ISkill*> searchResult;
		ImGui::InputText("##SpellName", str0, IM_ARRAYSIZE(str0));

		ImGui::SameLine();

		if (ImGui::Button("Search Spell")) {
			searchResult = Skill::search_skill_id_by_name(str0);
		}

		if (ImGui::ListBox("Search Result", &current_search_skill, searchResult))
		{

		}

		if (ImGui::Button("Add To Recover MP Spell List")) {
			if (!searchResult.empty() && current_search_skill >= 0 && current_search_skill <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.recover_mp_spell_list.push_back(searchResult[current_search_skill]);
					++settings.current_mp_heal_spell_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Recover MP Spell List"))
		{
			if (!settings.recover_mp_spell_list.empty() && settings.current_mp_heal_spell_selection >= 0 && settings.current_mp_heal_spell_selection <= settings.recover_mp_spell_list.size() + 1)
			{
				settings.recover_mp_spell_list.erase(settings.recover_mp_spell_list.begin() + settings.current_mp_heal_spell_selection);
				--settings.current_mp_heal_spell_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##7"))
		{
			settings.recover_mp_spell_list.clear();
		}

		ImGui::ListBox("Recover MP Spells Priority", &settings.current_mp_heal_spell_selection, settings.recover_mp_spell_list);
	}
	
	// Item heals and open
	
	// Heal HP Items
	if (listBox_Selection == 8)
	{
		static int current_search_item = -1;

		std::vector<uint32_t> searchResult = Inventory::get_all_consumeable_item();

		if (ImGui::ListBox("Consumeable Items", &current_search_item, searchResult))
		{

		}

		if (ImGui::Button("Add To Recover HP Item List")) {
			if (!searchResult.empty() && current_search_item >= 0 && current_search_item <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.recover_hp_item_list.push_back(searchResult[current_search_item]);
					++settings.current_hp_item_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Recover HP Item List"))
		{
			if (!settings.recover_hp_item_list.empty() && settings.current_hp_item_selection >= 0 && settings.current_hp_item_selection <= settings.recover_hp_item_list.size() + 1)
			{
				settings.recover_hp_item_list.erase(settings.recover_hp_item_list.begin() + settings.current_hp_item_selection);
				--settings.current_hp_item_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##8"))
		{
			settings.recover_hp_item_list.clear();
		}

		ImGui::ListBox("Recover HP Item Priority", &settings.current_hp_item_selection, settings.recover_hp_item_list);
	}

	
	// Heal MP Items
	if (listBox_Selection == 9)
	{
		static int current_search_item = -1;

		std::vector<uint32_t> searchResult = Inventory::get_all_unidentified_item();

		if (ImGui::ListBox("Unidentified Items", &current_search_item, searchResult))
		{

		}

		if (ImGui::Button("Add To Recover MP Item List")) {
			if (!searchResult.empty() && current_search_item >= 0 && current_search_item <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.recover_mp_item_list.push_back(searchResult[current_search_item]);
					++settings.current_mp_item_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Recover MP Item List"))
		{
			if (!settings.recover_mp_item_list.empty() && settings.current_mp_item_selection >= 0 && settings.current_mp_item_selection <= settings.recover_mp_item_list.size() + 1)
			{
				settings.recover_mp_item_list.erase(settings.recover_mp_item_list.begin() + settings.current_mp_item_selection);
				--settings.current_mp_item_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##9"))
		{
			settings.recover_mp_item_list.clear();
		}

		ImGui::ListBox("Recover HP Item Priority", &settings.current_mp_item_selection, settings.recover_mp_item_list);
	}

	// Open Purses
	if (listBox_Selection == 10)
	{
		static int current_search_item = -1;

		std::vector<uint32_t> searchResult = Inventory::get_all_unidentified_item();

		if (ImGui::ListBox("Unidentified Items", &current_search_item, searchResult))
		{

		}

		if (ImGui::Button("Add To Open Item List")) {
			if (!searchResult.empty() && current_search_item >= 0 && current_search_item <= searchResult.size() + 1)
			{
				if (LocalPlayerFinder::GetClientEntity())
				{
					settings.open_item_list.push_back(searchResult[current_search_item]);
					++settings.current_open_item_selection;
				}
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Remove From Open Item List"))
		{
			if (!settings.open_item_list.empty() && settings.current_open_item_selection >= 0 && settings.current_open_item_selection <= settings.open_item_list.size() + 1)
			{
				settings.open_item_list.erase(settings.open_item_list.begin() + settings.current_open_item_selection);
				--settings.current_open_item_selection;
			}
		}

		ImGui::SameLine();
		if (ImGui::Button("Clear List##10"))
		{
			settings.open_item_list.clear();
		}

		ImGui::ListBox("Open Item List Priority", &settings.current_open_item_selection, settings.open_item_list);
	}


	// -- Item Heals and Open


	ImGui::Separator();

	ImGui::Columns(2);

	if (ImGui::Button("Save settings"))
	{
		settings.SaveSettings();
	}

	ImGui::SameLine();

	if (ImGui::Button("Load Settings"))
	{
		settings.LoadSettings();
	}

	ImGui::NextColumn();
	ImGui::Text("Current Grind Status: %s", "Idling...");
	ImGui::Text("Current Gamestage: %s", World::GetCurrentStageStr());
	ImGui::End();
}

std::vector<uint32_t> skill_to_id(std::vector<ISkill*> skillList)
{
	std::vector<uint32_t> spellId;

	for (auto itr : skillList)
	{
		spellId.push_back(itr->SkillId);
	}

	return spellId;
}

std::vector<ISkill*> id_to_skill(std::vector<uint32_t> IdList)
{
	std::vector<ISkill*> skillList;

	for (auto itr : IdList)
	{
		skillList.push_back(Skill::get_skill_by_id(itr));
	}

	return skillList;
}

void Settings::SaveSettings()
{
	std::vector<uint32_t> attack_spells = skill_to_id(settings.attack_spell_list);
	std::vector<uint32_t> buff_spells = skill_to_id(settings.buff_spell_list);
	std::vector<uint32_t> cleanse_spells = skill_to_id(settings.cleanse_spell_list);
	std::vector<uint32_t> hp_spells = skill_to_id(settings.recover_hp_spell_list);
	std::vector<uint32_t> mp_spells = skill_to_id(settings.recover_mp_spell_list);

	json hp_items(settings.recover_hp_item_list);
	json mp_items(settings.recover_mp_item_list);
	json open_items(settings.open_item_list);
	json whitelist_mobs(settings.whitelist_monsters);
	json blacklist_mobs(settings.blacklist_monsters);
	json attack_spells_j(attack_spells);
	json buff_spells_j(buff_spells);
	json cleanse_spells_j(cleanse_spells);
	json hp_spells_j(hp_spells);
	json mp_spells_j(mp_spells);
	json item_open_list(settings.open_item_list);

	json wander_path;

	ns::to_json(wander_path, settings.wander_path_list);

	json SaveObj = {
		{"Toggles", {
			{"Fly_Hack", bFlyHack},
			{"No_Fall_Dmg", bNoFallDamage},
			{"Memory_Editor", b_MemoryEditor},
			{"Log_Console", b_Console},
			{"Grindbot_Menu", b_GrindMenu},
			{"Lua_Exec", b_LuaMenu},
			{"Radar", b_Radar},
			{"Packet_Editor", b_PacketEditor}
		}},

		{"Sliders", {
			{"Player_Speed", speedMultiplier},
			{"Animation_Speed", animationMultiplier}
		}},

		{"GrindBot", {
			{"Loot_Items", settings.loot_items},
			{"Hide", settings.hide_from_players},
			{"Teleport2Mob", settings.teleport_to_next_mob},
			{"Deposit_Items", settings.deposit_items},
			{"Send_Mule", settings.send_to_mule},
			{"Rotate_Path", settings.go_back_to_beginning},
			{"Resurrect", settings.resurrect_after_death},
			{"Whitelist_mobs", whitelist_mobs},
			{"Blacklist_mobs", blacklist_mobs},
			{"Attack_spells", attack_spells_j},
			{"Buff_spells", buff_spells_j},
			{"Cleanse_spells", cleanse_spells_j},
			{"MP_spells", hp_spells_j},
			{"HP_spells", mp_spells_j},
			{"Open_Item_List", item_open_list},
			{"Wander_path", wander_path}
		}}
	};

	std::ofstream output("Doxycycline.json");
	output << std::setw(4) << SaveObj << std::endl;
	output.close();
}

void Settings::LoadSettings()
{
	std::ifstream inputs("Doxycycline.json");
	if (!inputs.fail() && !is_empty(inputs)) {
		json curSettings; inputs >> curSettings;
		json Toggles = curSettings["Toggles"];
		{
			bFlyHack = Toggles["Fly_Hack"];
			bNoFallDamage = Toggles["No_Fall_Dmg"];
			b_MemoryEditor = Toggles["Memory_Editor"];
			b_Console = Toggles["Log_Console"];
			b_GrindMenu = Toggles["Grindbot_Menu"];
			b_LuaMenu = Toggles["Lua_Exec"];
			b_Radar = Toggles["Radar"];
			b_PacketEditor = Toggles["Packet_Editor"];
		}

		json Sliders = curSettings["Sliders"];
		{
			speedMultiplier = Sliders["Player_Speed"];
			SetPlayerStatSpeed(speedMultiplier);
			animationMultiplier = Sliders["Animation_Speed"];
			SetPlayerAnimationSpeed(animationMultiplier);
		}

		json Grindbot = curSettings["GrindBot"];
		{
			std::vector<uint32_t> attack_spells_v, buff_spells_v, cleanse_spells_v, HP_spells_v, MP_spells_v;

			settings.loot_items = Grindbot["Loot_Items"];
			settings.hide_from_players = Grindbot["Hide"];
			settings.teleport_to_next_mob = Grindbot["Teleport2Mob"];
			settings.deposit_items = Grindbot["Deposit_Items"];
			settings.send_to_mule = Grindbot["Send_Mule"];
			settings.go_back_to_beginning = Grindbot["Rotate_Path"];
			settings.resurrect_after_death = Grindbot["Resurrect"];
			settings.whitelist_monsters = Grindbot["Whitelist_mobs"].get<std::vector<std::string>>();
			settings.blacklist_monsters = Grindbot["Blacklist_mobs"].get<std::vector<std::string>>();
			settings.open_item_list = Grindbot["Open_Item_List"].get<std::vector<uint32_t>>();

			attack_spells_v = Grindbot["Attack_spells"].get<std::vector<uint32_t>>();
			buff_spells_v = Grindbot["Buff_spells"].get<std::vector<uint32_t>>();
			cleanse_spells_v = Grindbot["Cleanse_spells"].get<std::vector<uint32_t>>();
			HP_spells_v = Grindbot["MP_spells"].get<std::vector<uint32_t>>();
			MP_spells_v = Grindbot["HP_spells"].get<std::vector<uint32_t>>();

			settings.attack_spell_list = id_to_skill(attack_spells_v);
			settings.buff_spell_list = id_to_skill(buff_spells_v);
			settings.cleanse_spell_list = id_to_skill(cleanse_spells_v);
			settings.recover_hp_spell_list = id_to_skill(HP_spells_v);
			settings.recover_mp_spell_list = id_to_skill(MP_spells_v);
			settings.wander_path_list = ns::from_json(Grindbot["Wander_path"]);
		}


		inputs.close();
	}
}
