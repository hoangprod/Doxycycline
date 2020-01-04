
#ifndef PCH_H
#define PCH_H

// add headers that you want to pre-compile here

// Windows Header Files
#include <windows.h>
#include <stdio.h>
#include <d3d9types.h>
#include <d3d11.h>
#include <sstream>
#include <fstream>
#include <dinput.h>
#include <tchar.h>
#include "detours.h"
#include <vector>
#include <string>
#include <DXGI.h>
#include <mutex>
#include <algorithm>

// reference additional headers your program requires here
#include "Imgui/imgui.h"
#include "imgui/imgui_internal.h"
#include "imgui/examples/imgui_impl_win32.h"
#include "imgui/examples/imgui_impl_dx11.h"
#endif //PCH_H

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#define DIRECTINPUT_VERSION 0x0800
