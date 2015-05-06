##  LuaJIT / Lua 5.1 Sandbox
This is for LuaJIT 2.x.  This doesn't work in Lua5.1 but it will work with this source lua5.1 patch: http://coco.luajit.org/

Uses C debug hooks to keep unsafe lua code from running indefinitely!

NOTE: Be careful about what functions are passed to the environment of the unsafe lua code.  It is possible that C functions can hang and lua cannot yield in the middle of a c function.  For example, if the standard lua string funcs are exposed to the unsafe code running this in the unsafe code will cause a hang: "string.find(string.rep("a", 50), string.rep("a?", 50)..string.rep("a", 50))"

This is because Lua debug hooks cannot stop C from executing.

### Compiling
On linux run:

cmake .

make

### Allowing sandboxed code to be jit compiled
see here: http://lua-users.org/lists/lua-l/2011-06/msg00513.html

### Usage 
```lua
-- load library
local CoYield = require "CoYield"

-- global environment for this sandbox
local env = { print = print }

-- untrusted function
local function untrusted()
  print("It starts...") 
  while true do
    -- never quits
  end
  print("It finishes.")
end

-- safe wrapper function so errors do not make lua halt
local function safeCall()
	local success, msg = pcall(untrusted)
	if not success then
		print("ERROR: "..msg)
	end
end

-- both functions must be have jit disabled (unless you compile with jit hook checking which is disabled by default)
jit.off(untrusted, true)
jit.off(safeCall, true)

-- set the environment for the untrusted code
setfenv(untrusted, env)

-- turn this into a lua coroutine
local co = coroutine.create(safeCall)

-- now pass this coroutine to the c library which attaches itself to the untrusted code and forces it to yield
-- parameter #1 is the coroutine
-- parameter #2 is the number of lua bytecodes to run before forces the code to yield (pause)
CoYield.makeCoYield(co, 1000000) -- yield every 1 million instuctions

-- now the the c library does its magic and forces this function yield
-- this function acts the exact same as lua's coroutine.yield (even return values) but does a bit more to allow this library to work
CoYield.resume(co)

print("But it doesn't finish!")
