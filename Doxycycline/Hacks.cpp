#include "pch.h"
#include "Helper.h"
#include <iostream>
bool bFlyHack = false;
float speedMultiplier = 1.0;

void SetSpeed(float speed)
{
	float* pSpeed = (float*)((DWORD_PTR)HdnGetModuleBase("crysystem.dll") + 0x140270); // this offset needs to be sig scanned for at some point
	//std::cout << "pSpeed: " << pSpeed;
	*pSpeed = speed;
}