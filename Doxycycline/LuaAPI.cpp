#include "pch.h"
#include "LuaAPI.h"
#include "Scan.h"
#include "Helper.h"
#include "Menu.h"
f_lua_gettop lua_gettop;
f_lua_getfield lua_getfield;
f_lua_call lua_call;
f_lua_insert lua_insert;
f_lua_load lua_load;
f_lua_loadbuffer lua_loadbuffer;
f_lua_newthread lua_newthread;
f_lua_next lua_next;
f_lua_type lua_type;
f_lua_tonumber lua_tonumber;
f_lua_tolstring lua_tolstring;
f_lua_pcall lua_pcall;
f_lua_pushnil lua_pushnil;
f_lua_pushnumber lua_pushnumber;
f_lua_pushstring lua_pushstring;
f_lua_pushboolean lua_pushboolean;
f_lua_pushvalue lua_pushvalue;
f_lua_settop lua_settop;

void LuaError(const char* functionName)
{
	std::stringstream ss;
	ss << "Signature scan failed for lua function: " << functionName;
	console.AddLog(ss.str().c_str());
}

void LocateLuaFunctions()
{
	char* scriptSysBase = (char*)HdnGetModuleBase("CryScriptSystem.dll");
	UINT_PTR dwLen = 0x49EA0AA0;

	lua_gettop = (f_lua_gettop)PatternScan(scriptSysBase, dwLen, "\x48\x8B\x41\x10\x48\x2B\x41\x18", "xxxxxxxx");
	lua_getfield = (f_lua_getfield)PatternScan(scriptSysBase, dwLen, "\x48\x89\x5C\x24\x00\x48\x89\x74\x24\x00\x57\x48\x83\xEC\x30\x4D\x8B\xD0\x48\x8B\xF1\xE8\x00\x00\x00\x00\x48\x83\xC9\xFF\x48\x8B\xD8\x49\x8B\xFA\x33\xC0\x49\x8B\xD2\xF2\xAE\x48\xF7\xD1\x4C\x8D\x41\xFF\x48\x8B\xCE\xE8\x00\x00\x00\x00\x4C\x8B\x4E\x10\x4C\x8D\x44\x24\x00", "xxxx?xxxx?xxxxxxxxxxxx????xxxxxxxxxxxxxxxxxxxxxxxxxxxx????xxxxxxxx?");
	lua_call = (f_lua_call)PatternScan(scriptSysBase, dwLen, "\x48\x89\x5C\x24\x00\x57\x48\x83\xEC\x20\x8D\x42\x01", "xxxx?xxxxxxxx");
	lua_insert = (f_lua_insert)PatternScan(scriptSysBase, dwLen, "\x48\x83\xEC\x28\x4C\x8B\xD9", "xxxxxxx");
	lua_load = (f_lua_load)PatternScan(scriptSysBase, dwLen, "\x48\x89\x5C\x24\x00\x57\x48\x83\xEC\x50\x4D\x85\xC9", "xxxx?xxxxxxxx");
	lua_loadbuffer = (f_lua_loadbuffer)PatternScan(scriptSysBase, dwLen, "\x48\x83\xEC\x38\x48\x89\x54\x24\x00\x4C\x89\x44\x24\x00", "xxxxxxxx?xxxx?");
	lua_newthread = (f_lua_newthread)PatternScan(scriptSysBase, dwLen, "\x40\x53\x48\x83\xEC\x20\x48\x8B\x51\x20", "xxxxxxxxxx");
	lua_next = (f_lua_next)PatternScan(scriptSysBase, dwLen, "\x40\x53\x48\x83\xEC\x20\x48\x8B\xD9\xE8\x00\x00\x00\x00\x4C\x8B\x43\x10\x48\x8B\x10", "xxxxxxxxxx????xxxxxxx");
	lua_type = (f_lua_type)PatternScan(scriptSysBase, dwLen, "\x48\x83\xEC\x28\xE8\x00\x00\x00\x00\x48\x8D\x0D\x00\x00\x00\x00\x48\x3B\xC1\x75\x08", "xxxxx????xxx????xxxxx");
	lua_tonumber = (f_lua_tonumber)PatternScan(scriptSysBase, dwLen, "\x55\x8B\xEC\x8B\x4D\x0C\x8B\x55\x08\x83\xEC\x08\xE8\x00\x00\x00\x00\x83\x78\x04\x03\x74\x17", "xxxxxxxxxxxxx????xxxxxx");
	lua_tolstring = (f_lua_tolstring)PatternScan(scriptSysBase, dwLen, "\x48\x89\x5C\x24\x00\x48\x89\x74\x24\x00\x57\x48\x83\xEC\x20\x49\x8B\xD8\x8B\xF2", "xxxx?xxxx?xxxxxxxxxx");
	lua_pcall = (f_lua_pcall)PatternScan(scriptSysBase, dwLen, "\x48\x89\x5C\x24\x00\x57\x48\x83\xEC\x40\x41\x8B\xF8", "xxxx?xxxxxxxx");
	lua_pushnil = (f_lua_pushnil)PatternScan(scriptSysBase, dwLen, "\x48\x8B\x41\x10\xC7\x40\x00\x00\x00\x00\x00", "xxxxxx?????");
	lua_pushnumber = (f_lua_pushnumber)PatternScan(scriptSysBase, dwLen, "\x48\x8B\x41\x10\xF3\x0F\x11\x08", "xxxxxxxx");
	lua_pushstring = (f_lua_pushstring)PatternScan(scriptSysBase, dwLen, "\x48\x83\xEC\x28\x4C\x8B\xC9\x48\x85\xD2", "xxxxxxxxxx");
	lua_pushboolean = (f_lua_pushboolean)PatternScan(scriptSysBase, dwLen, "\x4C\x8B\x41\x10\x33\xC0", "xxxxxx");
	lua_pushvalue = (f_lua_pushvalue)PatternScan(scriptSysBase, dwLen, "\x48\x83\xEC\x28\x4C\x8B\xD1\xE8\x00\x00\x00\x00\x4D\x8B\x42\x10\x48\x8B\x10", "xxxxxxxx????xxxxxxx");
	lua_settop = (f_lua_settop)PatternScan(scriptSysBase, dwLen, "\x4C\x8B\xC1\x85\xD2\x78\x40", "xxxxxxx");

	if (!lua_gettop)
	{
		LuaError("lua_gettop");
	}
	if (!lua_getfield)
	{
		LuaError("lua_getfield");
	}
	if (!lua_call)
	{
		LuaError("lua_call");
	}
	if (!lua_insert)
	{
		LuaError("lua_insert");
	}
	if (!lua_load)
	{
		LuaError("lua_load");
	}
	if (!lua_loadbuffer)
	{
		LuaError("lua_loadbuffer");
	}
	if (!lua_newthread)
	{
		LuaError("lua_newthread");
	}
	if (!lua_next)
	{
		LuaError("lua_next");
	}
	if (!lua_type)
	{
		LuaError("lua_type");
	}
	if (!lua_tonumber)
	{
		LuaError("lua_tonumber");
	}
	if (!lua_tolstring)
	{
		LuaError("lua_tolstring");
	}
	if (!lua_pcall)
	{
		LuaError("lua_pcall");
	}
	if (!lua_pushnil)
	{
		LuaError("lua_pushnil");
	}
	if (!lua_pushnumber)
	{
		LuaError("lua_pushnumber");
	}
	if (!lua_pushstring)
	{
		LuaError("lua_pushstring");
	}
	if (!lua_pushboolean)
	{
		LuaError("lua_pushboolean");
	}
	if (!lua_pushvalue)
	{
		LuaError("lua_pushvalue");
	}
	if (!lua_settop)
	{
		LuaError("lua_settop");
	}
}