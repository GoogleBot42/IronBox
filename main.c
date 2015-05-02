#include "include/lua.h"
#include "include/lauxlib.h"

void CoYield_Yield(lua_State *L, lua_Debug *ar)
{
	lua_yield(L, 0);
}

int CoYield_MakeCoYield(lua_State *L)
{
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_State *L1 = lua_tothread(L, 1);
	lua_sethook(L1, CoYield_Yield, LUA_MASKCOUNT, 250);
	return 0;
}

int luaopen_libCoYield (lua_State *L)
{
	lua_pushcfunction(L, CoYield_MakeCoYield);
	return 1;
}
