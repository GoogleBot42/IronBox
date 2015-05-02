local MakeCoYield = require "libCoYield"

local env = {print = print}
local function CoFunc()
	print("I start...")
	while true do
		-- goes on forever
	end
	print("But I don't finish!")
end
local function error_handler(msg) print("ERROR: "..msg) end
local function safeCoFunc() xpcall(CoFunc,error_handler) end

setfenv(safeCoFunc,env)
local co = coroutine.create(CoFunc)
MakeCoYield(co)

coroutine.resume(co)

print("It stops!")
