#include "Radar.h"
#include "pch.h"
#include "GameClasses.h"
#include "Hacks.h"

Vec2 WorldToRadar(Vec3 location, Vec3 origin, float angle, int width, float scale = 16)
{
	float y_diff = location.x - origin.x;
	float x_diff = location.z - origin.z;
	int iRadarRadius = width;

	float flOffset = atanf(y_diff / x_diff);
	flOffset *= 180;
	flOffset /= m_PI;


	if ((x_diff < 0) && (y_diff >= 0))
		flOffset = 180 + flOffset;
	else if ((x_diff < 0) && (y_diff < 0))
		flOffset = 180 + flOffset;
	else if ((x_diff >= 0) && (y_diff < 0))
		flOffset = 360 + flOffset;

	y_diff = -1 * (sqrtf((x_diff * x_diff) + (y_diff * y_diff)));
	x_diff = 0;

	flOffset = angle - flOffset;

	flOffset *= m_PI;
	flOffset /= 180;

	float xnew_diff = x_diff * cosf(flOffset) - y_diff * sinf(flOffset);
	float ynew_diff = x_diff * sinf(flOffset) + y_diff * cosf(flOffset);

	xnew_diff /= scale;
	ynew_diff /= scale;

	xnew_diff = (iRadarRadius / 2) + (int)xnew_diff;
	ynew_diff = (iRadarRadius / 2) + (int)ynew_diff;

	// clamp x & y
	// FIXME: instead of using hardcoded "4" we should fix cliprect of the radar window
	if (xnew_diff > iRadarRadius)
		xnew_diff = iRadarRadius - 4;
	else if (xnew_diff < 4)
		xnew_diff = 4;

	if (ynew_diff> iRadarRadius)
		ynew_diff = iRadarRadius;
	else if (ynew_diff < 4)
		ynew_diff = 0;

	return Vec2(xnew_diff, ynew_diff);
}

void Radar::Render()
{
	ImGui::SetNextWindowSize(ImVec2(256, 256), 1);
	ImGui::SetNextWindowBgAlpha(0.8f);
	ImGui::SetNextWindowSizeConstraints(ImVec2(0, 0), ImVec2(FLT_MAX, FLT_MAX));

	if (ImGui::Begin("Radar", &bRadar, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoScrollbar))
	{
		ImDrawList* draw_list = ImGui::GetWindowDrawList();

		ImVec2 winpos = ImGui::GetWindowPos();
		ImVec2 winsize = ImGui::GetWindowSize();

		draw_list->AddLine(ImVec2(winpos.x + winsize.x * 0.5f, winpos.y), ImVec2(winpos.x + winsize.x * 0.5f, winpos.y + winsize.y), ImColor(255, 0, 0, 255), 1.f);
		draw_list->AddLine(ImVec2(winpos.x, winpos.y + winsize.y * 0.5f), ImVec2(winpos.x + winsize.x, winpos.y + winsize.y * 0.5f), ImColor(255, 0, 0, 255), 1.f);

		IEntity* localPlayer = LocalPlayerFinder::GetClientEntity();
		if (!localPlayer)
		{
			ImGui::End();
			return;
		}

		
		IEntityIt* it = SSystemGlobalEnvironment::GetInstance()->pEntitySystem->GetEntityIterator();
		while (!it->IsEnd())
		{
			IEntity* entity = it->Next();
			
			if (!entity || !entity->Name)
			{
				continue;
			}

			if (strcmp("Bonoru", entity->Name) == 0)
			{
				Vec2 screenPos = WorldToRadar(entity->GetWorldPos(), localPlayer->GetWorldPos(), localPlayer->GetFixedAngles().y, winsize.x, 4.5f);
				draw_list->AddCircleFilled(ImVec2(winpos.x + screenPos.x, winpos.y + screenPos.y), 4.5f, ImColor(192, 32, 32, 255));
			}
			
		}
		
	}

	ImGui::End();
}