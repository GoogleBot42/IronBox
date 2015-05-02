local CoYield = require "libCoYield"

local env = {print = print, j = 0}
local function CoFunc()
	print("h") 
	local i
	for i=1,2000 do 
		j=j+1 -- keeps luaJIT from optimizing this loop out of existence
	end
	print("/H")
end
local function safeCall()
	local success, msg = pcall(CoFunc)
	if not success then
		print("ERROR: "..msg)
	end
end
if jit then jit.off(CoFunc,true) end
if jit then jit.off(safeCall,true) end

setfenv(CoFunc,env)
local co = coroutine.create(safeCall)
CoYield.MakeCoYield(co)

local stillRunning = true
while stillRunning do
	-- must reenable yielding before each resume because otherwise the C function 
	-- does weird things and tries to yield outside this coroutine for some strange reason
	CoYield.ReenableYield()
	stillRunning = coroutine.resume(co)
	print(stillRunning, env.j, coroutine.status(co))
end
