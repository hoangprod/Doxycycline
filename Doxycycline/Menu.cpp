#include "pch.h"
#include "Imgui/examples/imgui_memory_editor.h"
#include "GameClasses.h"
#include "Hacks.h"
#include "LuaAPI.h"
#include "Radar.h"
#include "Helper.h"
#include "Combat.h"
#include "Menu.h"

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

extern bool g_HijackCtrl;
extern f_EncryptPacket o_EncryptPacket;

void PacketEditor::Replay(std::vector<char*> pVector, BYTE Element)
{
	o_EncryptPacket(packetinfo.sUnknown, 1, (__int64)pVector[Element], packetinfo.sClear);
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
			std::string str = std::to_string(element->SkillId) + std::string(" Name: ") + std::string(element->Name) + std::string(" range: ") /*+ std::to_string(element->maxRange);*/;
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

	static const char* listbox_combo[] = { "Wander Path", "Whitelist Mobs", "Blacklist Mobs", "Attack Spells", "Buff Spells", "Cleanse Spells", "Recv HP Spells", "Recv MP Spells", "Recv HP Items", "Recv MP Items", "Items to Open" };
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
		if (ImGui::Button("Clear List#1"))
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
			searchResult = Skill::get_skill_id_by_name(str0);
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
		if (ImGui::Button("Clear List#2"))
		{
			settings.attack_spell_list.clear();
		}

		ImGui::ListBox("Whitelist Mobs", &settings.current_attack_spell_selection, settings.attack_spell_list);
	}
	ImGui::Separator();

	if (ImGui::Button("Save settings"))
	{
		settings.wander_path_list.clear();
	}

	ImGui::SameLine();

	if (ImGui::Button("Load Settings"))
	{
		settings.wander_path_list.clear();
	}

	ImGui::SameLine();

	ImGui::Text("Grind Status: %s", "Idling...");
	ImGui::End();
}
