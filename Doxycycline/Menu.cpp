#include "pch.h"
#include "Imgui/examples/imgui_memory_editor.h"
#include "Menu.h"

MemoryEditor mem_edit;
Consolelogs console;
PacketEditor peditor;

const char* Data = "PlaceholderData";
ImU64* Address = (ImU64*)Data;
ImU32 Size = 15;
const ImU64 iStep = 1;

extern __int64 fakeKey;
extern __int64* sUnknown;
extern int* sClear;

typedef bool(__fastcall* f_EncryptPacket)(__int64* buffer, unsigned __int8 isEncrypted, __int64 key, int* cleartextbuffer);

extern f_EncryptPacket o_EncryptPacket;

void PacketEditor::Replay(std::vector<char*> pVector, BYTE Element)
{
	fakeKey = (__int64)pVector[Element];
	o_EncryptPacket(sUnknown, 1, fakeKey, sClear);
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
		ImGui::Text("[%d] - %02X %02X %02X %02X", element, *(BYTE*)i, *(BYTE*)(i + 1), *(BYTE*)(i + 2), *(BYTE*)(i + 3)); ImGui::SameLine();

		char* buttonID = (char*)"Replay##";
		char* buttonID2 = (char*)"Save##";
		char* buttonID3 = (char*)"Edit##";

		std::stringstream ss;
		ss << buttonID << element;
		std::stringstream sss;
		sss << buttonID2 << element;
		std::stringstream ssss;
		ssss << buttonID3 << element;

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
		element++;
	}
	ImGui::NextColumn();
	BYTE element2 = 0;
	for (auto i : SavedPackets) {
		ImGui::Text("[%d] - %02X %02X %02X %02X", element2, *(BYTE*)i, *(BYTE*)(i + 1), *(BYTE*)(i + 2), *(BYTE*)(i + 3)); ImGui::SameLine();

		char* buttonID = (char*)"Replay####";
		char* buttonID2 = (char*)"Remove####";
		char* buttonID3 = (char*)"Edit###";

		std::stringstream ss;
		ss << buttonID << element;
		std::stringstream sss;
		sss << buttonID2 << element;
		std::stringstream ssss;
		ssss << buttonID3 << element;
		if (ImGui::Button(ss.str().c_str()))
		{
			this->Replay(SavedPackets, element2);
		}
		ImGui::SameLine();
		if (ImGui::Button(sss.str().c_str()))
		{
			SavedPackets.erase(SavedPackets.begin() + element2);
		}
		ImGui::SameLine();
		if (ImGui::Button(ssss.str().c_str()))
		{
			this->Edit(SavedPackets, element2);
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
		WORD pSize = 0x2000;

		char* packet = new char[pSize];
		memcpy(packet, (void*)pBody, pSize);
		PacketsArr.push_back(packet);
	}
}

