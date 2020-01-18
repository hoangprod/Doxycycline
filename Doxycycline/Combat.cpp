#include "pch.h"
#include "Combat.h"
#include "Helper.h"

extern Addr Patterns;

typedef __int64(__fastcall* f_GetClientUnit)(unsigned int UnitId);
typedef char(__fastcall* f_UseSkillWrapper)(__int64 null, unsigned int skillId, __int64 Struct, char null_1, char null_2, char null_3);

f_GetClientUnit o_GetClientUnit = NULL;
f_UseSkillWrapper o_UseSkillWrapper = NULL;


Combat::Combat()
{
	o_GetClientUnit = (f_GetClientUnit)Patterns.Func_GetClientUnit;
	o_UseSkillWrapper = (f_UseSkillWrapper)Patterns.Func_CastSkillWrapper;
}

UINT_PTR Combat::get_local_unit()
{
	return *(UINT_PTR*)((*(UINT_PTR*)Patterns.Addr_UnitClass) + Patterns.Offset_LocalUnit);

}

DWORD Combat::get_current_target()
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return 0;

	return *(DWORD*)(LocalUnit + Patterns.Offset_CurrentTargetId);
}

BOOL Combat::set_current_target(DWORD targetId)
{
	UINT_PTR LocalUnit = get_local_unit();

	if (!LocalUnit)
		return false;

	*(DWORD*)(LocalUnit + Patterns.Offset_CurrentTargetId) = targetId;

	return true;
}

BOOL Combat::cast_skill_on_targetId(DWORD targetId, DWORD SkillId)
{
	if (set_current_target(targetId))
	{
		UINT_PTR LocalUnit = get_local_unit();

		if (LocalUnit)
		{
			DWORD info = *(DWORD*)(LocalUnit + 8);

			if (info)
			{
				SkillCastInformation Info(info);
				return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
			}
		}
	}
	return 0;
}

BOOL Combat::cast_skill_on_current_target(DWORD SkillId)
{
	if (get_current_target())
	{
		UINT_PTR LocalUnit = get_local_unit();

		if (LocalUnit)
		{
			DWORD info = *(DWORD*)(LocalUnit + 8);

			if (info)
			{
				SkillCastInformation Info(info);
				return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
			}
		}
	}

}

BOOL Combat::cast_skill_on_self(DWORD SkillId)
{
	UINT_PTR LocalUnit = get_local_unit();

	if (LocalUnit)
	{
		DWORD info = *(DWORD*)(LocalUnit + 8);

		if (info)
		{
			SkillCastInformation Info(info);
			return o_UseSkillWrapper(0, SkillId, (long long)&Info, 0, 0, 0);
		}
	}
}
