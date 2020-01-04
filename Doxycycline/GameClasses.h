#pragma once

// This header contains reversed game structures

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
	virtual void FindEntityByIdPossibly(unsigned int id); // one of these two functions is used to find an entity by ID. Not sure about the other. If both cause a crash when called, then change the parameter to uint16.
	virtual void FindEntityByIdPossiblyTwo(unsigned int id);
	virtual void FindEntityByName(const char* name); // tested and works
	virtual void Function17();
	virtual void RemoveEntity();
	virtual void Function19();
	virtual void GetNumEntities(); // works
	virtual void GetEntityIterator(); // works
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


class SSystemGlobalEnvironment
{
public:
	void *pSystem; //0x0000
	void *pGame; //0x0008
	void *pNetwork; //0x0010
	void *pRenderer; //0x0018
	void *pInput; //0x0020
	void *pTimer; //0x0028
	char pad_0030[16]; //0x0030
	void *possibleScriptSysThree; //0x0040
	void *possibleScriptSys; //0x0048
	void *possibleScriptSysTwo; //0x0050
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
		return *(SSystemGlobalEnvironment**)0x3CFAFAC8;
	}
}; //Size: 0x0440
