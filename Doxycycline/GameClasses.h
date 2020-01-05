#pragma once
#include "Helper.h"
// This header contains reversed game structures

class Matrix34
{
public:
	float Unk1; //0x0000
	float Unk2; //0x0004
	float Unk3; //0x0008
	float z; //0x000C
	float Unk5; //0x0010
	float Unk6; //0x0014
	float Unk7; //0x0018
	float x; //0x001C
	float Unk9; //0x0020
	float Unk10; //0x0024
	float Unk11; //0x0028
	float y; //0x002C
	float Unk12; //0x0030
	float Unk13; //0x0034
}; //Size: 0x0038

class Vec3
{
public:
	float x; //0x0000
	float z; //0x0004
	float y; //0x0008
}; //Size: 0x000C

class Quat
{
public:
	Vec3 v;
	float w;

	void Normalize()
	{
		// removed implementation
	}
};

struct AABB
{
	Vec3 min;
	Vec3 max;
	BOOL IsReset() { return min.x > max.x; }
};

class IEntity
{
public:
	char pad_0008[8]; //0x0008
	uint32_t N000001A7; //0x0010
	uint32_t ID; //0x0014
	char pad_0018[8]; //0x0018
	uint32_t Flags; //0x0020
	char pad_0024[4]; //0x0024
	char *Name; //0x0028
	char pad_0030[528]; //0x0030

	virtual uint32_t GetId();
	virtual void Function1();
	virtual void* GetClass();
	virtual void Function3();
	virtual void Function4();
	virtual void Function5();
	virtual void Function6(); // this looks like getflags?
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
	virtual void Function10();
	virtual void Function11();
	virtual const char* GetName(); // Use entity->Name over this function
	virtual void Function13();
	virtual void Function14();
	virtual void Function15();
	virtual void Function16();
	virtual void Function17();
	virtual void Function18();
	virtual void Function19();
	virtual void Function20();
	virtual void Function21();
	virtual void Function22();
	virtual void Function23();
	virtual const Matrix34& GetWorldTM(); // this is most likely incorrect but needs to be tested
	virtual void Function25();
	virtual void Function26();
	virtual void GetWorldBounds(AABB &bbox); // the AABB struct hasn't been tested. THis function may be valid 
	virtual void Function28();
	virtual void Function29();
	virtual void SetPos(Vec3 &vPos, int nWhyFlags);
	virtual Vec3& GetPos();
	virtual void SetRotation(const Quat& qRotation, int nWhyFlags = 0);
	virtual const Quat& GetRotation(); // this works
	virtual void Function34();
	virtual Vec3 GetScale();
	virtual void Function36();
	virtual void SetPosRotScale(const Vec3 &vPos, const Quat &qRotation, const Vec3 &vScale, int nWhyFlags = 0);
	virtual Vec3& GetWorldPos(); // This function works now. If any of the other Get functions return weird values, try making it return a reference with &
	virtual Vec3 GetWorldAngles(); // this works
	virtual Quat GetWorldRotation(); // This function worked in older versions but is giving me weird output. TODO: Discuss this/figure out if its fixable
	virtual void GetForwardDir();
	virtual void Function42();
	virtual void Function43();
	virtual void Function44();
	virtual void Function45();
	virtual void Function46();
	virtual void Function47();
	virtual void Function48();
	virtual void Function49();
	virtual void Function50();
	virtual void Function51();
	virtual void Function52(); // looks like EnablePhysics but it appears to be useless
	virtual void Function53();
	virtual void Function54();
	virtual void Function55();
	virtual void Function56(); // this used to be GetPhysics on x64 client. Not labeling because it appears that the vtable offset changed but idk
	virtual void Function57();
	virtual void Function58();
	virtual void Function59();
	virtual void Function60();
	virtual void Function61();
	virtual void GetWorldBBox();
	virtual void Function63();
	virtual void Function64();
	virtual void Function65();
	virtual void Function66();
	virtual void Function67();
	virtual void Function68();
	virtual void Function69();
	virtual void Function70();
	virtual void Function71();
	virtual void Function72();
	virtual void Function73();
	virtual void Function74();
	virtual void Function75();
	virtual void Function76();
	virtual void Function77();

	Vec3 GetFixedAngles()
	{
		Vec3 angles = GetWorldAngles();
		if (angles.y < 0)
		{
			angles.y = 6.28319 + angles.y;
		}

		angles.y = angles.y * (180.0 / 3.14159265358979323846);
		return angles;
	}
}; //Size: 0x0240

class IEntityIt // allows you to iterate through entities - basically the entity list
{
public:
	char pad_0008[56]; //0x0008

	virtual void Function0();
	virtual void Function1();
	virtual bool IsEnd(); // works
	virtual void Function3();
	virtual IEntity* Next(); // works
	virtual void Release();
	virtual void Function6();
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
}; //Size: 0x0040

class IEntitySystem
{
public:
	char pad_0008[120]; //0x0008

	virtual void MoveOrigin();
	virtual void DeferredMoveCellPostProcess();
	virtual void Function2();
	virtual void Function3();
	virtual void Function4();
	virtual void Function5();
	virtual void Function6();
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
	virtual void Function10();
	virtual void SpawnEntity();
	virtual void Function12();
	virtual void Function13();
	virtual IEntity* FindEntityById(uint32_t id); // tested and works
	virtual IEntity* SomethingToDoWithIDs(uint32_t id); // this function accepts an ID as a parameter but I'm not sure what it does.
	virtual IEntity* FindEntityByName(const char* name); // tested and works
	virtual void Function17();
	virtual void RemoveEntity();
	virtual void Function19();
	virtual uint32_t GetNumEntities(); // works
	virtual IEntityIt* GetEntityIterator(); // works
	virtual void Function22();
	virtual void Function23();
	virtual void Function24();
	virtual void Function25();
	virtual void Function26();
	virtual void Function27();
	virtual void Function28();
	virtual void Function29();
	virtual void Function30();
	virtual void Function31();
	virtual void Function32();
	virtual void Function33();
	virtual void Function34();
	virtual void Function35();
	virtual void Function36();
	virtual void Function37();
	virtual void Function38();
	virtual void Function39();
	virtual void Function40();
	virtual void Function41();
}; //Size: 0x0080

class IGameFramework
{
public:
	char pad_0008[120]; //0x0008

	virtual void Function0();
	virtual void Function1();
	virtual void Function2();
	virtual void Function3();
	virtual void Function4();
	virtual void Init();
	virtual void CompleteInit();
	virtual void Function7();
	virtual void PreUpdate();
	virtual void Function9();
	virtual void PostUpdate();
	virtual void Function11();
	virtual void Function12();
	virtual void Function13();
	virtual void Function14();
	virtual void Function15();
	virtual void Function16();
	virtual void Function17();
	virtual void Function18();
	virtual void Function19();
	virtual void* GetILevelSystem();
	virtual void* GetIActorSystem(); // pretty sure this is GetIActorSystem but it may actually be the function below or above
	virtual void* GetIItemSystem();
	virtual void Function23();
	virtual void Function24();
	virtual void Function25();
	virtual void Function26();
	virtual void Function27();
	virtual void Function28();
	virtual void Function29();
	virtual void Function30();
	virtual void Function31();
	virtual void Function32();
	virtual void Function33();
	virtual void Function34();
	virtual void Function35();
	virtual void Function36();
	virtual void Function37();
	virtual void Function38();
	virtual void Function39();
	virtual void Function40();
	virtual void* GetClientActor(); // works
	virtual uint32_t GetClientActorId(); // works. This ID is also the same as the client entity ID, so it can be used to grab local entity.
	virtual void Function43();
	virtual void GetServerTime();
	virtual void GetClientChannelId();
	virtual void Function46();
	virtual void Function47();
	virtual void GetGameObject();
	virtual void GetNetworkSafeClassId();
	virtual void Function50();
}; //Size: 0x0080

class IScriptSystem
{
public:
	char pad_0008[16]; //0x0008
	void* luaState; //0x0018
	int32_t PlaceHolderIgnore; //0x0020
	void* InvalidPlaceHolder; //0x0024
	char pad_002C[24]; //0x002C

	virtual void Function0();
	virtual void Function1();
	virtual void Function2();
	virtual void Function3();
	virtual void Function4();
	virtual void ExecuteFile();
	virtual void ExecuteBuffer();
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
	virtual void Function10();
	virtual void Function11();
	virtual void Function12();
	virtual void BeginCallOne();
	virtual void BeginCallTwo();
	virtual void BeginCallThree();
	virtual void BeginCallFour();
	virtual void EndCall();
	virtual void Function18();
	virtual void Function19();
	virtual void Function20();
	virtual void Function21();
	virtual void Function22();
	virtual void Function23();
	virtual void Function24();
	virtual void Function25();
	virtual void Function26();
	virtual void Function27();
	virtual void Function28();
	virtual void Function29();
	virtual void Function30();
	virtual void Function31();
	virtual void Function32();
	virtual void Function33();
	virtual void Function34();
	virtual void Function35();
	virtual void Function36();
	virtual void Function37();
	virtual void Function38();
	virtual void Function39();
	virtual void Function40();
	virtual void Function41();
}; //Size: 0x0044

class IGame
{
public:
	char pad_0008[32]; //0x0008
	IGameFramework* pGameFramework; //0x0028
	char pad_0030[144]; //0x0030

	virtual void Function0();
	virtual void Function1();
	virtual void Function2();
	virtual void Function3();
	virtual void Function4();
	virtual void Function5();
	virtual void Function6();
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
}; //Size: 0x00C0

class SSystemGlobalEnvironment
{
public:
	void *pSystem; //0x0000
	IGame *pGame; //0x0008
	void *pNetwork; //0x0010
	void *pRenderer; //0x0018
	void *pInput; //0x0020
	void *pTimer; //0x0028
	char pad_0030[16]; //0x0030
	IScriptSystem* scriptSysOne; //0x0040
	IScriptSystem* scriptSysTwo; //0x0048
	IScriptSystem* ScriptSysThree; //0x0050
	void *p3DEngine; //0x0058
	void *pSoundSystem; //0x0060
	void *pMusicSystem; //0x0068
	void *pPhysicalWorld; //0x0070
	void *pMovieSystem; //0x0078
	void *pAISystem; //0x0080
	IEntitySystem *pEntitySystem; //0x0088
	void *pCryFont; //0x0090
	void *pCryPak; //0x0098
	char pad_00A0[928]; //0x00A0

	static SSystemGlobalEnvironment* GetInstance()
	{
		// Pattern scan this
		return *(SSystemGlobalEnvironment**)((UINT_PTR)HdnGetModuleBase("x2game.dll") + 0x3FAFAC8);
	}
}; //Size: 0x0440

class LocalPlayerFinder
{
public:
	static unsigned int GetClientActorId() // this should also return the entity
	{
		return SSystemGlobalEnvironment::GetInstance()->pGame->pGameFramework->GetClientActorId();
	}

	static void* GetClientActor()
	{
		return SSystemGlobalEnvironment::GetInstance()->pGame->pGameFramework->GetClientActor();
	}

	static IEntity* GetClientEntity()
	{
		return SSystemGlobalEnvironment::GetInstance()->pEntitySystem->FindEntityById(LocalPlayerFinder::GetClientActorId());
	}
};