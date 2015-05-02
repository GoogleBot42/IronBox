#include "include/lua.h"
#include "include/lauxlib.h"

char enabled = 1;

void CoYield_Yield(lua_State *L, lua_Debug *ar)
{
	if (enabled)
	{
		enabled = 0;
		lua_yield(L, 0);
	}
}

int CoYield_MakeCoYield(lua_State *L)
{
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_State *L1 = lua_tothread(L, 1);
	lua_sethook(L1, CoYield_Yield, LUA_MASKCOUNT, 1000);
	return 0;
}

int CoYield_ReenableYield(lua_State *L)
{
	enabled = 1;
	return 0;
}

static const struct luaL_reg CoYield [] = {
      {"MakeCoYield", CoYield_MakeCoYield},
      {"ReenableYield", CoYield_ReenableYield},
      {NULL, NULL}
};

int luaopen_libCoYield (lua_State *L)
{
	luaL_register(L, NULL, CoYield);
	return 1;
}
