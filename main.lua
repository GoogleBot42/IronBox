local MakeCoYield = require "libCoYield"

local env = {print = print}
local function CoFunc()
	print("I start...")
	while true do
		-- goes on forever
	end
	print("But I don't finish!")
end if jit then jit.off(hang,true) end

setfenv(CoFunc,env)
local co = coroutine.create(CoFunc)
MakeCoYield(co)

coroutine.resume(co)

print("It stops!")
