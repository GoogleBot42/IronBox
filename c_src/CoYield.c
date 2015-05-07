// The MIT License (MIT)
// 
// Copyright (c) 2015 Matthew J. Runyan
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include "include/lua.h"
#include "include/lauxlib.h"
#include <limits.h>

#define DEFUALT_INSTRUCTIONS 100000
#define MINIMUM_INSTRUCTIONS 1000

char enabled = 1;

static void CoYield_Yield(lua_State *L, lua_Debug *ar)
{
	if (enabled)
	{
		enabled = 0;
		lua_yield(L, 0);
	}
}

static int CoYield_MakeCoYield(lua_State *L)
{
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_State *L1 = lua_tothread(L, 1);
	
	int instructions = DEFUALT_INSTRUCTIONS;
	if (lua_gettop(L) >= 2 && !lua_isnil(L, 2))
	{
		lua_Number tmp = luaL_checknumber(L, 2);
		if (tmp > (lua_Number)INT_MAX)
			instructions = INT_MAX;
		else if (tmp < (lua_Number)MINIMUM_INSTRUCTIONS)
			instructions = MINIMUM_INSTRUCTIONS;
		else
			instructions = (int)tmp;
	}
	
	lua_sethook(L1, CoYield_Yield, LUA_MASKCOUNT, instructions);
	return 0;
}

static void CoYeild_CallLuaYieldFunc(lua_State *L) //, lua_State* thread)
{
	luaL_checktype(L, 1, LUA_TTHREAD);
	// thread, ...
	
	lua_getglobal(L, "coroutine");
	// thread, ..., coroutine_t
	
	lua_insert(L, 2);
	// thread, coroutine_t, ...
	
	if (!lua_istable(L, 2))
		luaL_error(L, "Global coroutine is not a table");
	lua_getfield(L, 2, "resume");
	if (!lua_isfunction(L, -1))
		luaL_error(L, "coroutine.resume is not a function");
	// thread, coroutine_t, ..., function
	
	lua_remove(L, 2);
	// thread, ..., function
	
	lua_insert(L, 1);
	// function, thread, ...
	
	lua_call(L, lua_gettop(L) - 1, LUA_MULTRET);
}

static int CoYeild_Resume(lua_State *L)
{
	enabled = 1;
	CoYeild_CallLuaYieldFunc(L);
	enabled = 0;
	return lua_gettop(L);
}

static const struct luaL_reg CoYield [] = {
      {"makeCoYield", CoYield_MakeCoYield},
      {"resume", CoYeild_Resume},
      {NULL, NULL}
};

#ifdef _WIN32
__declspec(dllexport) int luaopen_CoYield (lua_State *L)
#else
int luaopen_CoYield (lua_State *L)
#endif
{
	luaL_register(L, "\0", CoYield);
	return 1;
}
