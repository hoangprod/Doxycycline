#pragma once

typedef int(__cdecl* f_lua_gettop)(void* lua_State);
typedef void(__cdecl* f_lua_getfield)(void* lua_State, int index, const char* k);
typedef void(__cdecl* f_lua_call)(void* lua_State, int nargs, int nresults, int errFunc);
typedef void(__cdecl* f_lua_insert)(void* lua_State, int index);
typedef int(__cdecl* f_lua_load)(void* lua_State, int reader, void* data, const char* chunkname);
typedef int(__cdecl* f_lua_loadbuffer)(void* lua_State, const char* buff, size_t sz, const char* name);
typedef void*(__cdecl* f_lua_newthread)(void* lua_State);
typedef int(__cdecl* f_lua_next)(void* lua_State, int idx);
typedef int(__cdecl* f_lua_type)(void* lua_State, int index);
typedef float(__cdecl* f_lua_tonumber)(void* lua_State, int idx);
typedef const char *(__cdecl* f_lua_tolstring)(void* lua_State, int idx, size_t *len);
typedef int(__cdecl* f_lua_pcall)(void* lua_State, int nargs, int nresults, int errfunc);
typedef int(__cdecl* f_lua_pushnil)(void* lua_State);
typedef int(__cdecl* f_lua_pushnumber)(void* lua_State, float value);
typedef int(__cdecl* f_lua_pushstring)(void* lua_State, const char* s);
typedef int(__cdecl* f_lua_pushboolean)(void* lua_State, int b);
typedef int(__cdecl* f_lua_pushvalue)(void* lua_State, int indedx);
typedef int(__cdecl* f_lua_settop)(void* lua_State, int idx);

extern f_lua_gettop lua_gettop;
extern f_lua_getfield lua_getfield;
extern f_lua_call lua_call;
extern f_lua_insert lua_insert;
extern f_lua_load lua_load;
extern f_lua_loadbuffer lua_loadbuffer;
extern f_lua_newthread lua_newthread;
extern f_lua_next lua_next;
extern f_lua_type lua_type;
extern f_lua_tonumber lua_tonumber;
extern f_lua_tolstring lua_tolstring;
extern f_lua_pcall lua_pcall;
extern f_lua_pushnil lua_pushnil;
extern f_lua_pushnumber lua_pushnumber;
extern f_lua_pushstring lua_pushstring;
extern f_lua_pushboolean lua_pushboolean;
extern f_lua_pushvalue lua_pushvalue;
extern f_lua_settop lua_settop;

extern void* luaState1;
extern void* luaState2;

#define lua_tostring(L,i)	lua_tolstring(L, (i), NULL)
#define lua_getglobal(L,s)	lua_getfield(L, -10002, (s))
#define lua_istable(L,n)	(lua_type(L, (n)) == 5)
#define lua_isnil(L,n)		(lua_type(L, (n)) == 0)
#define lua_isboolean(L,n)	(lua_type(L, (n)) == 1)
#define lua_pop(L,n)		lua_settop(L, -(n)-1)
#define lua_isfunction(L,n)	(lua_type(L, (n)) == 6)

void lua_c_LoadLuaFile(void* lua_State, const char* path);
void lua_c_ExecuteLuaString(void* lua_State, const char* buffer);

void LocateLuaFunctions();