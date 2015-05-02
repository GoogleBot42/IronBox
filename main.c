#include "include/lua.h"
#include "include/lauxlib.h"

char enabled = 1;

void CoYield_Yield(lua_State *L, lua_Debug *ar)
{
	printf("Yielding... ");
	if (enabled)
	{
		printf("Yielded\n");
		enabled = 0;
		lua_yield(L, 0);
	}
}

int CoYield_MakeCoYield(lua_State *L)
{
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_State *L1 = lua_tothread(L, 1);
	lua_sethook(L1, CoYield_Yield, LUA_MASKCOUNT, 250);
	return 0;
}

int CoYield_EnableYield(lua_State *L)
{
	enabled = 1;
	return 0;
}

static const struct luaL_reg CoYield [] = {
      {"MakeCoYield", CoYield_MakeCoYield},
      {"EnableYield", CoYield_EnableYield},
      {NULL, NULL}
};

int luaopen_libCoYield (lua_State *L)
{
	luaL_register(L, "CoYield", CoYield);
	return 1;
}
