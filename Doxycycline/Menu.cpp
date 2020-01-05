#include "pch.h"
#include "Imgui/examples/imgui_memory_editor.h"
#include "Menu.h"
#include "GameClasses.h"
#include "Hacks.h"
#include "LuaAPI.h"
MemoryEditor mem_edit;
Consolelogs console;
PacketEditor peditor;
HackView hackView;

const char* Data = "PlaceholderData";
ImU64* Address = (ImU64*)Data;
ImU32 Size = 15;
const ImU64 iStep = 1;

packetCrypto packetinfo;

bool b_displayLocalPlayerInfo = false;


typedef bool(__fastcall* f_EncryptPacket)(__int64* buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer);

extern f_EncryptPacket o_EncryptPacket;

void PacketEditor::Replay(std::vector<char*> pVector, BYTE Element)
{
	o_EncryptPacket(packetinfo.sUnknown, 1, (__int64)pVector[Element], packetinfo.sClear);
}

void MenuRender()
{
	static bool p_open = true;
	console.Draw("Console Logs", &p_open);

	{
		ImGui::Begin("Memory Editor");
		ImGui::InputScalar(" Address", ImGuiDataType_S64, &Address, &iStep, NULL, "%016X", ImGuiInputTextFlags_CharsHexadecimal);
		ImGui::InputScalar(" Size", ImGuiDataType_U32, &Size, &iStep, NULL, "%x");
		mem_edit.DrawContents(Address, Size);
		ImGui::End();
	}

	peditor.Display();
	hackView.Display();
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
			console.AddLog("replay 2");
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
		if (PacketsArr.size() > 15) {
			Pop();
		}
		WORD pSize = 0x400;

		char* packet = new char[pSize];
		memcpy(packet, (void*)pBody, pSize);
		PacketsArr.push_back(packet);
	}
}


void HackView::Display()
{
	ImGui::Begin("Hacks");

	ImGui::Checkbox("Fly Hack", &bFlyHack);
	if (ImGui::Checkbox("No Fall Damage", &bNoFallDamage))
	{
		ToggleNoFall(bNoFallDamage);
	}

	if (ImGui::SliderFloat("Player Speed", &speedMultiplier, 1.0f, 50.0f))
	{
		SetPlayerSpeed(speedMultiplier);
	}

	if (ImGui::Button("Test lua"))
	{
		lua_c_ExecuteLuaString(SSystemGlobalEnvironment::GetInstance()->pScriptSysTwo->luaState, "X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED,\"Executing \")");
	}

	ImGui::Checkbox("Display local player debug info", &b_displayLocalPlayerInfo);
	if (b_displayLocalPlayerInfo)
	{
		if (LocalPlayerFinder::GetClientActorId())
		{
			IEntity* localEnt = LocalPlayerFinder::GetClientEntity();
			void* localActor = LocalPlayerFinder::GetClientActor();
			if (localEnt)
			{
				std::stringstream entAddressStrm;
				std::stringstream actorAddressStrm;
				std::stringstream positionStrm;
				std::stringstream angleStrm;
				std::stringstream rotationStrm;

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


	ImGui::End();
}
