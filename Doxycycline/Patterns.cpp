#include "pch.h"
#include "Scan.h"
#include "Helper.h"

Addr Patterns;

bool __stdcall findPatterns()
{
	char* x2GameModule = (char*)HdnGetModuleBase("x2game.dll");
	char* CrySystemModule = (char*)HdnGetModuleBase("crysystem.dll");
	char* CryNetworkModule = (char*)HdnGetModuleBase("CryNetwork.dll");
	char* CryRenderModule = (char*)HdnGetModuleBase("CryRenderD3D10.dll");

	printf("------------------ [ START PATTERN SCAN ] ------------------\n\n");

	//////////////////////////////////////////////////////////////////[ STATIC ADDRESSES ]///////////////////////////////////////////////////////////////////////////////

	printf("------------------ [ STATIC ADDRESSES ] ------------------\n\n");

	Patterns.Addr_isAutoPathing = (BYTE*)ptr_offset_Scanner(x2GameModule, 0x300000, "\xc6\x05\xCC\xCC\xCC\x01\x01\xe8\xCC\xCC\xCC\xCC\x84\xc0", 0, 6, 2, "xx???xxx????xx") + 1; // + 1 because its a weird write instruction

	if (!Patterns.Addr_isAutoPathing)
	{
		printf("[Error] Patterns.Addr_isAutoPathing failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_isAutoPathing is at %llx\n", (UINT_PTR)Patterns.Addr_isAutoPathing); };

	Patterns.Addr_SpeedModifier = (FLOAT*)ptr_offset_Scanner(CrySystemModule, 0x100000, "\xf3\x44\xCC\xCC\xCC\xCC\xCC\xCC\x00\x84\xc0\x0f\x84\xCC\x00\x00\x00\x48\x8b\x06\x48\x8b\xce", 0, 9, 5, "xx??????xxxxx?xxxxxxxxx");

	if (!Patterns.Addr_SpeedModifier)
	{
		printf("[Error] Patterns.Addr_SpeedModifier failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_SpeedModifier is at %llx\n", (UINT_PTR)Patterns.Addr_SpeedModifier); };

	Patterns.Addr_gEnv = (UINT_PTR)ptr_offset_Scanner(x2GameModule, 0x800000, "\x48\x8b\x05\xCC\xCC\xCC\xCC\x80\xb8\xCC\xCC\x00\x00\x00\x74\xCC\x48", 0, 7, 3, "xxx????xx??xxxx?x");

	if (!Patterns.Addr_gEnv)
	{
		printf("[Error] Patterns.Addr_gEnv failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_gEnv is at %llx\n", (UINT_PTR)Patterns.Addr_gEnv); };

	Patterns.Addr_UnitClass = (UINT_PTR)ptr_offset_Scanner(x2GameModule, 0x800000, "\x48\x8b\x05\xCC\xCC\xCC\x00\x44\x8b\xf1\x48\x8b\xb0\xCC\xCC\x00\x00", 0, 7, 3, "xxx???xxxxxxx??xx");

	if (!Patterns.Addr_UnitClass)
	{
		printf("[Error] Patterns.Addr_UnitClass failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_UnitClass is at %llx\n", (UINT_PTR)Patterns.Addr_UnitClass); };

	Patterns.Addr_LootClass = (UINT_PTR)ptr_offset_Scanner(x2GameModule, 0x2000000, "\x48\x8b\x0d\xCC\xCC\xCC\x00\x8b\xd3\xe8\xCC\xCC\xCC\x00\x84\xc0\x74", 0, 7, 3, "xxx???xxxx???xxxx");

	if (!Patterns.Addr_LootClass)
	{
		printf("[Error] Patterns.Addr_LootClass failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Addr_LootClass is at %llx\n", (UINT_PTR)Patterns.Addr_LootClass); };

	//////////////////////////////////////////////////////////////////[ OFFSETS ]///////////////////////////////////////////////////////////////////////////////

	printf("\n------------------ [ OFFSETS ] ------------------\n\n");


	Patterns.Offset_Swapchain = (DWORD)Scan_Offsets(CryRenderModule, 0x300000, "\x48\x8b\x8b\xCC\xCC\xCC\x00\x48\x8b\x01\xff\x50\x40\x8b\xf8\x3d\x21\x00\x7a\x88", "xxx???xxxxxxxxxxxxxx", 3, 4);

	if (!Patterns.Offset_Swapchain)
	{
		printf("[Error] Patterns.Offset_Swapchain failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_Swapchain is at %llx\n", (UINT_PTR)Patterns.Offset_Swapchain); };

	Patterns.Offset_LocalUnit = (DWORD)Scan_Offsets(x2GameModule, 0x800000, "\x48\x8b\xb0\xCC\xCC\x00\x00\x48\x85\xf6\x75\xCC\x32\xc0\x48\x81\xc4", "xxx??xxxxxx?xxxxx", 3, 4);

	if (!Patterns.Offset_LocalUnit)
	{
		printf("[Error] Patterns.Offset_LocalUnit failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_LocalUnit is at %llx\n", (UINT_PTR)Patterns.Offset_LocalUnit); };

	Patterns.Offset_ActorUnitModel = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x48\x83\xec\x28\x48\x8b\x89\xCC\xCC\x00\x00\x48\x8b\x01\xff\x90\xCC\xCC\x00\x00\xf3\x0f\x10\x40", "xxxxxxx??xxxxxxx??xxxxxx", 7, 4);

	if (!Patterns.Offset_ActorUnitModel)
	{
		printf("[Error] Patterns.Offset_ActorUnitModel failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_ActorUnitModel is at %llx\n", (UINT_PTR)Patterns.Offset_ActorUnitModel); };

	Patterns.Offset_UserStats = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x48\x83\xec\x38\x48\x8b\x89\xCC\xCC\x00\x00\xf3\x0f\x11\x4c\xCC\xCC\xf3\x0f\x11\x4c", "xxxxxxx??xxxxxx??xxxx", 7, 4);

	if (!Patterns.Offset_UserStats)
	{
		printf("[Error] Patterns.Offset_UserStats failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_UserStats is at %llx\n", (UINT_PTR)Patterns.Offset_UserStats); };


	Patterns.Offset_SpeedStat = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\xF3\x0F\x10\xB3\xCC\xCC\x00\x00\x48\x8B\xCB\xF3\x0F\x59\xCC\xCC\xE8", "xxxx??xxxxxxxx??x", 4, 4);

	if (!Patterns.Offset_SpeedStat)
	{
		printf("[Error] Patterns.Offset_SpeedStat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_SpeedStat is at %llx\n", (UINT_PTR)Patterns.Offset_SpeedStat); };

	Patterns.Offset_CurrentTargetId = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x8b\x80\xCC\xCC\x00\x00\xeb\xCC\x40\x32\xf6\x8b\x05\xCC\xCC\xCC\x03", "xx??xxx?xxxxx???x", 2, 4);

	if (!Patterns.Offset_CurrentTargetId)
	{
		printf("[Error] Patterns.Offset_CurrentTargetId failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_CurrentTargetId is at %llx\n", (UINT_PTR)Patterns.Offset_CurrentTargetId); };


	Patterns.Offset_isInCombat = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x0f\xb6\x81\xCC\xCC\x00\x00\xc7\x44\x24\x28\x02\x00\x00\x00", "xxx??xxxxxxxxxx", 3, 4);

	if (!Patterns.Offset_isInCombat)
	{
		printf("[Error] Patterns.Offset_isInCombat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_isInCombat is at %llx\n", (UINT_PTR)Patterns.Offset_isInCombat); };

	Patterns.Offset_IsUnitInCombat = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x80\xB9\x00\x00\x00\x00\x00\x75\x12\x48\x8B\x01", "xx?????xxxxx", 2, 4);

	if (!Patterns.Offset_IsUnitInCombat)
	{
		printf("[Error] Patterns.Offset_IsUnitInCombat failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_IsUnitInCombat is at %llx\n", (UINT_PTR)Patterns.Offset_IsUnitInCombat); };

	Patterns.Offset_isDead = (UINT_PTR)Scan_Offsets(x2GameModule, 0x800000, "\x80\xbb\xCC\xCC\x00\x00\x00\x0f\xCC\xCC\xCC\x00\x00\x45\x33\xc0\x33\xd2", "xx??xxxx???xxxxxxx", 2, 4);

	if (!Patterns.Offset_isDead)
	{
		printf("[Error] Patterns.Offset_isDead failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Offset_isDead is at %llx\n", (UINT_PTR)Patterns.Offset_isDead); };

	//////////////////////////////////////////////////////////////////[ FUNCTIONS ]///////////////////////////////////////////////////////////////////////////////

	printf("\n------------------ [ FUNCTIONS ] ------------------\n\n");

	Patterns.Func_EncryptPacket = (UINT_PTR)PatternScan(CryNetworkModule, 0x100000, "\x4c\x89\x4c\x24\x20\x55\x56\x57\x41\x54\x41\x55\x41\x56\x41\x57\x48\x8d\xac", "xxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_EncryptPacket)
	{
		printf("[Error] Patterns.Func_EncryptPacket failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_EncryptPacket is at %llx\n", Patterns.Func_EncryptPacket); };

	Patterns.Func_SendEncryptPacket = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x40\x57\xb8\x40\xfe\x00\x00\xe8", "xxxxxxxx");

	if (!Patterns.Func_SendEncryptPacket)
	{
		printf("[Error] Patterns.Func_SendEncryptPacket failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_SendEncryptPacket is at %llx\n", Patterns.Func_SendEncryptPacket); };

	Patterns.Func_UpdateSwimCaller = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x0f\x28\xc8\xf3\x0f\x5c\xCC\xCC\x00\x00\x00\x41\x0f\x2f\xcc", "xxxxxx??xxxxxxx");

	if (!Patterns.Func_UpdateSwimCaller)
	{
		printf("[Error] Patterns.Func_UpdateSwimCaller failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_UpdateSwimCaller is at %llx\n", Patterns.Func_UpdateSwimCaller); };

	Patterns.Func_GetSetNavPath = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x48\x8b\xc4\x57\x48\x83\xec\x60\x48\xc7\x44\x24\x20\xfe\xff\xff\xff\x48\x89\x58\x10\x48\x89\x68\x18\x48\x89\x70\x20\x48\x8b\xf2\x48\x8b\xd9", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_GetSetNavPath)
	{
		printf("[Error] Patterns.Func_GetSetNavPath failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetSetNavPath is at %llx\n", Patterns.Func_GetSetNavPath); };

	Patterns.Func_GetClientUnit = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x3b\x0d\xCC\xCC\xCC\xCC\x74\xCC\x4c\x8b\x05\xCC\xCC\xCC\x03\x49\x8b\xd0", "xx????x?xxx???xxxx");

	if (!Patterns.Func_GetClientUnit)
	{
		printf("[Error] Patterns.Func_GetClientUnit failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetClientUnit is at %llx\n", Patterns.Func_GetClientUnit); };

	Patterns.Func_CastSkillWrapper = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x48\x89\x5c\x24\x18\x48\x89\x74\x24\x20\x89\x54\x24\x10\x55\x57\x41\x54", "xxxxxxxxxxxxxxxxxx");

	if (!Patterns.Func_CastSkillWrapper)
	{
		printf("[Error] Patterns.Func_CastSkillWrapper failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_CastSkillWrapper is at %llx\n", Patterns.Func_CastSkillWrapper); };

	Patterns.Func_LootAll = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x48\x89\x5c\x24\x18\x57\x48\x83\xec\xCC\x48\x8b\x05\xCC\xCC\xCC\x03", "xxxxxxxxx?xxx???x");

	if (!Patterns.Func_LootAll)
	{
		printf("[Error] Patterns.Func_LootAll failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_LootAll is at %llx\n", Patterns.Func_LootAll); };

	Patterns.Func_isLootable = (UINT_PTR)PatternScan(x2GameModule, 0x1000000, "\x40\x53\x48\x83\xec\x20\x48\x8b\xd9\x8b\xca\xe8\xCC\xCC\xCC\x00\x48\x8b\x53", "xxxxxxxxxxxx???xxxx");

	if (!Patterns.Func_isLootable)
	{
		printf("[Error] Patterns.Func_isLootable failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_isLootable is at %llx\n", Patterns.Func_isLootable); };

	// PATTERN SCAN FOR GETSKILLBYID HERE
	Patterns.Func_GetSkillByID = (UINT_PTR)ptr_offset_Scanner(x2GameModule, 0x300000, "\xe8\xCC\xCC\xCC\x00\x48\x8b\xd8\x48\x85\xc0\x0f\xCC\xCC\x00\x00\x00\xf6", 0, 5, 1, "x???xxxxxxxx??xxxx");

	if (!Patterns.Func_GetSkillByID)
	{
		printf("[Error] Patterns.Func_GetSkillByID failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetSkillByID is at %llx\n", Patterns.Func_GetSkillByID); };

	Patterns.Func_GetSkillCooldown = (UINT_PTR)PatternScan(x2GameModule, 0x1000000, "\x48\x83\xec\x28\x48\x8b\xc1\x48\x8b\x0d\xCC\xCC\xCC\x00\x48\x85\xc9\x74", "xxxxxxxxxx???xxxxx");

	if (!Patterns.Func_GetSkillCooldown)
	{
		printf("[Error] Patterns.Func_GetSkillCooldown failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetSkillCooldown is at %llx\n", Patterns.Func_GetSkillCooldown); };

	Patterns.Func_GetIndexVelocity = (UINT_PTR)ptr_offset_Scanner(x2GameModule, 0x200000, "\xe8\xCC\xCC\xCC\x00\x0f\x57\xf6\xf3\x0f\x59\x05\xCC\xCC\xCC\x00", 0, 5, 1, "x???xxxxxxxx???x");

	if (!Patterns.Func_GetIndexVelocity)
	{
		printf("[Error] Patterns.Func_GetIndexVelocity failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_GetIndexVelocity is at %llx\n", (UINT_PTR)Patterns.Func_GetIndexVelocity); };

	Patterns.Func_AI_IsCasting = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x4C\x8B\xD8\x48\x85\xC0\x75\x05\x48\x83\xC4\x28\xC3\x8B\x05\x00\x00\x00\x00\x41\x39\x83\x00\x00\x00\x00\x75\x16", "xxxxxxx????xxxxxxxxxxxxxxx????xxx????xx");

	if (!Patterns.Func_AI_IsCasting)
	{
		printf("[Error] Patterns.Func_AI_IsCasting failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_IsCasting is at %llx\n", Patterns.Func_AI_IsCasting); };

	Patterns.Func_AI_StopCasting = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x89\x54\x24\x10\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x48\x85\xC0\x74\x51\x48\x8B\x05\x00\x00\x00\x00\x48\x83\xB8\x00\x00\x00\x00\x00\x74\x15\x48\x8B\x80\x00\x00\x00\x00\x8B\x48\x08\x48\x8D\x44\x24\x00\x89\x4C\x24\x40", "xxxxxxxxxxx????xxxxxxxx????xxx?????xxxxx????xxxxxxx?xxxx");

	if (!Patterns.Func_AI_StopCasting)
	{
		printf("[Error] Patterns.Func_AI_StopCasting failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_StopCasting is at %llx\n", Patterns.Func_AI_StopCasting); };

	Patterns.Func_AI_IsChanneling = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x48\x83\xEC\x28\x8B\xCA\xE8\x00\x00\x00\x00\x4C\x8B\xD8\x48\x85\xC0\x75\x05\x48\x83\xC4\x28\xC3\x8B\x80\x00\x00\x00\x00", "xxxxxxx????xxxxxxxxxxxxxxx????");

	if (!Patterns.Func_AI_IsChanneling)
	{
		printf("[Error] Patterns.Func_AI_IsChanneling failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_IsChanneling is at %llx\n", Patterns.Func_AI_IsChanneling); };

	Patterns.Func_AI_GetGlobalCooldown = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x44\x89\x44\x24\x00\x48\x83\xEC\x38\x8B\xCA", "xxxx?xxxxxx");

	if (!Patterns.Func_AI_GetGlobalCooldown)
	{
		printf("[Error] Patterns.Func_AI_GetGlobalCooldown failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_GetGlobalCooldown is at %llx\n", Patterns.Func_AI_GetGlobalCooldown); };

	Patterns.Func_AI_CheckBuff = (UINT_PTR)PatternScan(x2GameModule, 0x800000, "\x44\x89\x44\x24\x00\x48\x83\xEC\x28\x8B\xCA", "xxxx?xxxxxx");

	if (!Patterns.Func_AI_CheckBuff)
	{
		printf("[Error] Patterns.Func_AI_CheckBuff failed to pattern scan.\n");
		return FALSE;
	}
	else { printf("[Pattern Scan]  Patterns.Func_AI_CheckBuff is at %llx\n", Patterns.Func_AI_CheckBuff); };


	printf("\n------------------ [ END PATTERN SCAN ] ------------------\n\n");

	return TRUE;
}