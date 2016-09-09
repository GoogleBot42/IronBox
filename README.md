##  LuaJIT / Lua 5.1 IronBox (a.k.a. a super awesome Sandbox)
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

print("And it stops!")
```
You can have as many IronBox's as you want.
```lua
local box1 = IronBox.create("while true do end") -- initialize with a string
local box2 = IronBox.create(function() while true do end end)

box1()
box2()
box1()
box2()
-- they are started and resumed correctly without a c boundary errors that would pop up if pure lua was used
```
You can initialize with a sandbox with specific environment.  A default safe environment is used if this argument is empty.  Also a custom error function can be specified as well.
```lua
local function error_hand(msg, box) -- msg holds the error box is the ironbox that had the error
	print("There was an error!")
end

-- use default environment with custom error handler
local box1 = IronBox.create("while true do", nil, error_hand)
-- error_hand is called: syntax error

-- empty environment and default error handler (this just prints error to console)
local box2 = IronBox.create(function() print("test") end, {})
-- print has not been exposed to this IronBox.  But this box hasn't run yet so no error

box1() -- does nothing because creation of box was unsucssful
assert(box1.co == nil) -- if this is true then the box failed to initialize and the error handler was called

box2() -- error msg is sent to default error handler which prints error to console
```
