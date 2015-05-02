-- The MIT License (MIT)
-- 
-- Copyright (c) 2015 Matthew J. Runyan
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

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
