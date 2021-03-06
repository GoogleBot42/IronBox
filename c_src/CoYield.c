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
#include <string.h>

#define DEFAULT_INSTRUCTIONS 100000
#define MINIMUM_INSTRUCTIONS 1000 // having any less than this likely will cause performance issues because of so much switching

int justYielded = 0;

static void CoYield_Yield(lua_State *L, lua_Debug *ar)
{
	justYielded = 1;
	lua_yield(L, 0);
}

static int CoYield_MakeCoYield(lua_State *L)
{
	// get and  lua thread (first arg)
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_State *L1 = lua_tothread(L, 1);
	
	// get number of instructions (second arg)
	int instructions = DEFAULT_INSTRUCTIONS;
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

static int CoYeild_Resume(lua_State *L)
{
	// same as ( LUA_REGISTRYINDEX["CoYield_lib"][1] )(...)
	luaL_checktype(L, 1, LUA_TTHREAD);
	lua_getfield(L, LUA_REGISTRYINDEX, "CoYield_lib");
	lua_rawgeti(L, -1, 1);
	lua_remove(L, -2);
	lua_insert(L, 1);
	// run the coroutine (a.k.a. where the magic happens)
	lua_call(L, lua_gettop(L) - 1, LUA_MULTRET);
	
	// now replace the bool status returned by lua's resume with more descript stuff
	if (justYielded) {
		justYielded = 0;
		lua_pushboolean(L, 0); // coroutine is paused
	} else {
		lua_pushboolean(L, 1); // coroutine is finished
		// remove coroutine error message.  it doesn't really matter
		if (lua_isstring(L, 2) && strcmp(lua_tolstring(L, 2, NULL), "cannot resume dead coroutine") == 0)
			lua_remove(L, 2);
	}
	lua_replace(L, 1); // replace the first arg with the boolean
	
	return lua_gettop(L);
}

static void CoYeild_SaveGlobalLuaCoResumeFunc(lua_State *L)
{
	// same as: LUA_REGISTRYINDEX["CoYield_lib"] = { coroutine.resume }
	
	// create table in private space
	lua_createtable(L, 1, 0);
	// get "coroutine.resume" and save this function to the table at position zero
	lua_getglobal(L, "coroutine");
	if (!lua_istable(L, -1))
		luaL_error(L, "Global coroutine is not a table.");
	lua_getfield(L, -1, "resume");
	if (!lua_iscfunction(L, -1))
		luaL_error(L, "The global \"coroutine.resume\" is not a c function.");
	lua_remove(L, -2);
	lua_rawseti(L, -2, 1);
	// push this table to the private space
	lua_setfield(L, LUA_REGISTRYINDEX, "CoYield_lib");
}

static const struct luaL_reg CoYield_lib [] = {
      {"makeCoYield", CoYield_MakeCoYield},
      {"resume", CoYeild_Resume},
      {NULL, NULL}
};

#ifndef __declspec
#define __declspec(a)
#endif
__declspec(dllexport) int luaopen_CoYield (lua_State *L)
{
	CoYeild_SaveGlobalLuaCoResumeFunc(L);
	luaL_register(L, "CoYield", CoYield_lib);
	return 1;
}
