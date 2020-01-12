#pragma once

extern bool bFlyHack;
extern bool bNoFallDamage;
extern float speedMultiplier;
extern float animationMultiplier;
extern Vec3 pathPosition_DoNotModify;
extern bool bRadar;

void SetPlayerAnimationSpeed(float speed);
void SetPlayerStatSpeed(float speed);
void ToggleNoFall(bool bEnable);
bool PathToPosition(Vec3 vec = {0.0f, 0.0f, 0.0f});