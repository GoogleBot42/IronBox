##  LuaJIT / Lua 5.1 Sandbox
This is for LuaJIT 2.x.  This doesn't work in Lua5.1 but it will work with this source lua5.1 patch: http://coco.luajit.org/ or you can just use this with the patch already added: https://github.com/GoogleBot42/Lua-5.1.5-Coco

Uses C debug hooks to allow pausing unsafe code in multiple coroutines.

NOTE: Be careful about what functions are passed to the environment of the unsafe lua code.  It is possible that C functions can hang and lua cannot yield in the middle of a c function.  For example, if the standard lua string funcs are exposed to the unsafe code running this in the unsafe code will cause a hang: "string.find(string.rep("a", 50), string.rep("a?", 50)..string.rep("a", 50))"

This is because Lua debug hooks cannot stop C from executing.

### Compiling
On Linux:
```
cmake .
make
cd IronBox
luajit test.lua
```
On Windows:
Open cmake gui and configure and generate a VS project
Open the project and set to release mode and build
Run test.lua in luajit.

### Allowing sandboxed code to be jit compiled
see here: http://lua-users.org/lists/lua-l/2011-06/msg00513.html

### Usage 
```lua
-- load library
local IronBox = require "IronBox"

local box = IronBox.create(function() 
	while true do 
		-- never exits
	end 
	print("I don't finish :(")
end)

-- run the box
box() -- box:resume() works too
-- ding! The box has surpassed the executing limit.  Pausing the coroutine

-- continue the box
box()
-- stops again

print("And they stop!")
```
