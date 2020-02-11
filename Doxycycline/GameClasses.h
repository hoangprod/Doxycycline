#pragma once
# define m_PI 3.14159265358979323846
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
	//Vec3(float x_, float y_, float z_) : x(x_), y(y_), z(z_) {}
	std::string Str() {return std::to_string(x) + ", " + std::to_string(y) + ", " + std::to_string(z);}
	float x; //0x0000
	float z; //0x0004
	float y; //0x0008
}; //Size: 0x000C

class Vec2
{
public:
	float x;
	float y;

	Vec2()
	{

	}

	Vec2(float X, float Y)
	{
		x = X;
		y = Y;
	}

	// equality
	bool operator==(const Vec2& v) const;
	bool operator!=(const Vec2& v) const;

	// arithmetic operations
	Vec2&	operator+=(const Vec2 &v)
	{
		x += v.x;
		y += v.y;
		return *this;
	}

	Vec2&	operator-=(const Vec2 &v)
	{
		x -= v.x;
		y -= v.y;
		return *this;
	}
	Vec2&	operator*=(const Vec2 &v);
	Vec2&	operator*=(float s);
	Vec2&	operator/=(const Vec2 &v);
	Vec2&	operator/=(float s);

	float length()
	{
		return sqrt((x * x) + (y * y));
	}

	void Normalize()
	{
		float vecLength = length();
		float multiplier = 1 / vecLength;
		x = x * multiplier;
		y = y * multiplier;
	}
};

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


class ClientDoodad
{
public:
	char pad_0008[96]; //0x0008
	int16_t N00000FD4; //0x0068
	char pad_006A[2]; //0x006A
	Vec3 Position; //0x006C
	char pad_0078[8]; //0x0078
	int32_t ID; //0x0080
	char pad_0084[188]; //0x0084

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
}; //Size: 0x0140

class CAIObject
{
public:
	char pad_0008[56]; //0x0008

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
	virtual void Function10();
	virtual void Function11();
	virtual void Function12();
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
	virtual bool IsHostile(CAIObject* pOther, bool bUsingAIIgnorePlayer = true);
	virtual void Function35();
	virtual void Function36();
	virtual void Function37();
	virtual void Function38();
	virtual void Function39();
	virtual void Function40();
	virtual void Function41();
}; //Size: 0x0040

class IEntityClass
{
public:
	int32_t flags; //0x0008
	char pad_000C[4]; //0x000C
	char *name; //0x0010
	char *scriptFile; //0x0018
	char pad_0020[32]; //0x0020

	virtual void Function0();
	virtual void GetName();
	virtual void GetFlags();
	virtual void SetFlags();
	virtual void GetScriptFile();
	virtual void GetSystem();
	virtual void GetScriptTable();
	virtual void GetEventHandler();
	virtual void Function8();
	virtual void Function9();
}; //Size: 0x0040

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

	virtual uint32_t GetEntityID();
	virtual void Function1();
	virtual IEntityClass* GetEntityClass();
	virtual void Function3();
	virtual void Function4();
	virtual void Function5();
	virtual void GetFlags(); // this looks like getflags?
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
	virtual CAIObject* GetAI();
	virtual bool HasAI();
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

	// Custom
	Vec3 GetFixedAngles();


}; //Size: 0x0240

class IEntityIt // allows you to iterate through entities - basically the entity list
{
public:
	char pad_0008[56]; //0x0008

	virtual void Constructor();
	virtual void AddRef();
	virtual bool IsEnd(); // works
	virtual IEntity* Next(); // works
	virtual IEntity* MoveFirst(); // works
	virtual void Release();
	virtual void Function6();
	virtual void Function7();
	virtual void Function8();
	virtual void Function9();
}; //Size: 0x0040

class Buff
{
public:
	uint32_t BuffId; //0x0000
	char pad_0004[116]; //0x0004
	char* BuffDescription; //0x0078
	char pad_0080[136]; //0x0080
	uint32_t isBuff; //0x0108
	char pad_010C[36]; //0x010C
	char* BuffName; //0x0130
	char pad_0138[72]; //0x0138
}; //Size: 0x0180

class CItem {
public:
	std::string Name;
	bool isUnidentified;
	bool isConsumable;
	bool isSellable;
	uint8_t soulBoundEnum;
	uint32_t slot;
	uint32_t itemId;
	uint32_t MaxStack;
	uint32_t currentStack;
	uint32_t skillType;
	uint32_t usageEnum;
	uint32_t levelRequirement;
};


class CSkill
{
public:
	uint32_t SkillId;
	char* Name;
	char* abilityType;
	int learnLevel;
	int levelStep;
	bool show;
	float minRange;
	float maxRange;
	int ManaCost;
	int castingTime;
	int cooldownTime;
	int nextLearnLevel;
	int firstLearnLevel;
	bool isHarmful;
	bool isHelpful;
	bool isMeleeAttack;
	bool hasRange;
	int upgradeCost;
	int skillPoints;
	int effectiveRange;
};


class ISkill
{
public:
	int32_t SkillId; //0x0000
	char pad_0004[116]; //0x0004
	uint32_t cooldown; //0x0078
	char pad_007C[20]; //0x007C
	char* Description; //0x0090
	char pad_0098[88]; //0x0098
	char* Name; //0x00F0
	char pad_00F8[576]; //0x00F8
}; //Size: 0x0338


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

class IActor
{
public:
	char pad_0008[16]; //0x0008
	IEntity *Entity; //0x0018
	char pad_0020[64]; //0x0020
	uint32_t unitID; //0x0060
	char pad_0064[540]; //0x0064

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
	virtual void Function10();
	virtual void Function11();
	virtual void Function12();
	virtual void Function13();
	virtual void Function14();
	virtual void Function15();
	virtual void Function16();
	virtual void Function17();
	virtual void Function18();
	virtual void Function19();
	virtual void Function20();
	virtual void Function21();
	virtual void GetHealth();
	virtual void GetHealthAsRoundedPercentage();
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
	virtual void IsActive();
	virtual void Function43();
	virtual void Function44();
	virtual void Function45();
	virtual void Function46();
	virtual void Function47();
	virtual void Function48();
	virtual void Function49();
	virtual void IsHidden();
	virtual void Function51();
	virtual void Function52();
	virtual void IsInvisible();
	virtual void Function54();
	virtual void Function55();
	virtual void Function56();
	virtual void Function57();
	virtual void Function58();
	virtual void Function59();
	virtual void Function60();
	virtual void Function61();
	virtual void Function62();
	virtual void Function63();
	virtual void Function64();
	virtual void Function65();
	virtual void GetPhysics();
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
	virtual void Function78();
	virtual void Function79();
	virtual void Function80();
	virtual void Function81();
	virtual void Function82();
	virtual void Function83();
	virtual void Function84();
	virtual void Function85();
	virtual void Function86();
	virtual void Function87();
	virtual void Function88();
	virtual void Function89();
	virtual void Function90();
	virtual void Function91();
	virtual void Function92();
	virtual void Function93();
	virtual void Function94();
	virtual void UpdateScriptStats();
	virtual void Function96();
	virtual void CreateScriptEvent();
	virtual void Function98();
	virtual void Function99();
	virtual void Function100();
	virtual void Function101();
	virtual void DumpActorInfo();
	virtual void LikelyIsFriendlyEntity();
	virtual void SetIK();
	virtual void ProcessFrameMovementRotation();
	virtual void ProcessFrameMovement();
	virtual void UpdateSwimStats();
	virtual void Function108();
	virtual void Function109();
	virtual void Function110();
	virtual void PrePhysicsUpdate();
	virtual void Function112();
	virtual void OnStanceChanged();
	virtual void Function114();
	virtual void PossibleIsFriendly();
	virtual void DrawIK();
	virtual void Function117();
	virtual void Function118();
	virtual void Function119();
	virtual void Function120();
	virtual void Function121();
	virtual void Function122();
	virtual void Function123();
	virtual void Function124();
	virtual void Function125();
	virtual void Function126();
	virtual void Function127();
	virtual void Function128();
	virtual void Function129();
	virtual void Function130();
	virtual void Function131();
	virtual void Function132();
	virtual void Function133();
	virtual void Function134();
	virtual void Function135();
	virtual void Function136();
	virtual void Function137();
	virtual void Function138();
	virtual void Function139();
	virtual void Function140();
	virtual void Function141();
	virtual void Function142();
	virtual void Function143();
	virtual void Function144();
	virtual void Function145();
	virtual void Function146();
	virtual void Function147();
	virtual void Function148();
	virtual void Function149();
	virtual void Function150();
	virtual void Function151();
	virtual void Function152();
	virtual void Function153();
	virtual void Function154();
	virtual void Function155();
	virtual void Function156();
	virtual void Function157();
	virtual void Function158();
	virtual void Function159();
	virtual void Function160();
	virtual void Function161();
	virtual void Function162();
	virtual void Function163();
	virtual void Function164();
	virtual void Function165();
	virtual void Function166();
	virtual void Function167();
	virtual void Function168();
	virtual void Function169();
}; //Size: 0x0280

class IActorSystem
{
public:
	char pad_0008[32]; //0x0008
	int32_t actorCount; //0x0028
	char pad_002C[20]; //0x002C

	virtual void* Disabled_CreateActorIterator();
	virtual void CreateActor();
	virtual IActor* GetActor(uint32_t entID);
	virtual void GetActorByChannelId();
	virtual int GetActorCount();
	virtual void GetActorParams();
	virtual void AddActor();
	virtual void RemoveActor();
	virtual void Function8();
	virtual void Function9();
}; //Size: 0x0040

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
	virtual IActorSystem* GetIActorSystem(); // pretty sure this is GetIActorSystem but it may actually be the function below or above
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
	virtual IActor* GetClientActor();
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
	void *luaState; //0x0018
	char pad_0020[32]; //0x0020

	virtual void Function0();
	virtual void Function1();
	virtual void Function2();
	virtual void Update();
	virtual void SetGCFrequency();
	virtual void ExecuteFile(const char* sFileName, bool bRaiseError, bool bForceReload); // Don't call this function because it only loads files from the game pak
	virtual void ExecuteBuffer(const char* sBuffer, unsigned long nSize, const char* sBufferDescription);
	virtual void UnloadScript(); // This and the next 3 functions below might not work
	virtual void UnloadScripts();
	virtual void ReloadScript();
	virtual void ReloadScripts();
	virtual void DumpLoadedScripts();
	virtual void CreateTable();
	virtual void BeginCallOne(void* pTable, const char* sFuncName);
	virtual void BeginCallTwo(const char* sTableName, const char* sFuncName);
	virtual void BeginCallThree(const char* sFuncName);
	virtual void BeginCallFour(void* hFunc);
	virtual void EndCall();
	virtual void EndCallAny();
	virtual void EndCallAnyN();
	virtual void GetFunctionPtr1();
	virtual void GetFunctionPtr2();
	virtual void CompareFuncRef();
	virtual void CloneAny();
	virtual void ReleaseAny();
	virtual void SetGlobalAny();
	virtual void GetGlobalAny();
	virtual void PushFuncParamAny();
	virtual void CreateUserData();
	virtual void ForceGarbageCollection();
	virtual void GetGCCount();
	virtual void nullsub1();
	virtual void Release();
	virtual void ShowDebugger();
	virtual void AddBreakpoint();
	virtual void GetLocalVariables();
	virtual void Function36();
	virtual void Function37();
	virtual void Function38();
	virtual void Function39();
	virtual void Function40();
	virtual void Function41();
	virtual void Function42();
	virtual void Function43();
	virtual void Function44();
	virtual void Function45();
	virtual void Function46();
	virtual void Function47();
	virtual void Function48();
	virtual void Function49();
	virtual void RetrieveLuaStateAndCallSomeOtherFunc();
	virtual void Function51();
	virtual void Function52();
	virtual void Function53();
	virtual void Function54();
	virtual void Function55();
	virtual void Function56();
	virtual void Function57();
}; //Size: 0x0040

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
	IScriptSystem* pScriptSysOne; //0x0040
	IScriptSystem* pScriptSysTwo; //0x0048
	IScriptSystem* pScriptSysThree; //0x0050
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

	static SSystemGlobalEnvironment* GetInstance();
}; //Size: 0x0440

class LocalPlayerFinder
{
public:
	static unsigned int GetClientActorId() // this should also return the entity
	{
		return SSystemGlobalEnvironment::GetInstance()->pGame->pGameFramework->GetClientActorId();
	}

	static IActor* GetClientActor()
	{
		return SSystemGlobalEnvironment::GetInstance()->pGame->pGameFramework->GetClientActor();
	}

	static IEntity* GetClientEntity()
	{
		return SSystemGlobalEnvironment::GetInstance()->pEntitySystem->FindEntityById(LocalPlayerFinder::GetClientActorId());
	}

	static std::vector<IActor*> GetActorList()
	{
		std::vector<IActor*> actorList;
		IEntityIt* entIt = SSystemGlobalEnvironment::GetInstance()->pEntitySystem->GetEntityIterator();
		if (entIt)
		{
			while (!entIt->IsEnd())
			{
				if (IEntity* ent = entIt->Next())
				{
					IActor* actor = SSystemGlobalEnvironment::GetInstance()->pGame->pGameFramework->GetIActorSystem()->GetActor(ent->GetEntityID());
					if (actor)
					{
						GetClientActor()->Entity->GetAI()->IsHostile(ent->GetAI(), true);

						actorList.push_back(actor);
					}
				}
			}
		}

		return actorList;
	}
};

class EntityHelper
{
public:
	static bool isHostile(IEntity* entity)
	{
		return LocalPlayerFinder::GetClientEntity()->GetAI()->IsHostile(entity->GetAI(), true);
	}

	static bool isPlayer(IEntity* entity)
	{
		if (entity->GetEntityClass()->flags == 33)
			return true;
		return false;
	}

	static bool isNpcMob(IEntity* entity)
	{
		if (entity->GetEntityClass()->flags == 41)
			return true;
		return false;
	}

	static bool isMount(IEntity* entity)
	{
		if (entity->GetEntityClass()->flags == 57)
			return true;
		return false;
	}
};


extern std::vector<ClientDoodad> doodadList;