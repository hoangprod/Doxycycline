#pragma once

extern bool bFlyHack;
extern bool bNoFallDamage;
extern float speedMultiplier;
extern Vec3 pathPosition_DoNotModify;

void SetPlayerSpeed(float speed);
void ToggleNoFall(bool bEnable);
bool PathToPosition(Vec3 vec = {0.0f, 0.0f, 0.0f});