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

local CoYield = require "CoYield"
local envGen = require "SandboxEnv"

local IronBox = {}

local function table_combine(t1, t2)
	for i, v in pairs(t2) do
		t1[i] = v
	end
end

local function default_errorfunc(msg)
	print("Error in IronBox sandbox: " .. msg)
end

local IronBox__meta = {
	__call = function(box, ...)
		return box:resume(...)
	end,
	
	__index = {
		resume = function(box, ...)
			if type(box.co) == "thread" then
				CoYield.resume(box.co, ...)
			end
		end,
	},
}

local function createIronBoxObject(co, env)
	return setmetatable({ co = co, env = env }, IronBox__meta)
end

function IronBox.create(untrusted, env, errorfunc)
	-- type checks
	assert(type(untrusted) == "string" or type(untrusted) == "function")
	if type(errorfunc) ~= "function" then
		errorfunc = default_errorfunc
		if jit then jit.off(errorfunc,true) end
	end
	
	-- extract options and create environment
	local instructionsCount
	if env then
		if env._useDefault then
			table_combine(env, envGen())
		end
		if type(env._count) == "number" then
			instructionsCount = env._count
		end
		env._noDefault = nil
		env._count = nil
	else
		env = envGen()
	end
	
	-- get function from string if necessary
	if type(untrusted) == 'string' then
		local msg
		untrusted, msg = loadstring(untrusted)
		if untrusted == nil then
			errorfunc(msg)
			return createIronBoxObject(nil, env)
		end
	end
	
	-- set environment
	setfenv(untrusted,env)
	
	-- create safe wrapper function
	local safefunc = function(...)
		local ok, result = pcall(untrusted, ...)
		if not ok then
			errorfunc(result)
		end
		return result
	end
	if jit then jit.off(untrusted,true) end
	if jit then jit.off(safefunc,true) end
	
	-- create safe coroutine
	local co = coroutine.create(safefunc)
	CoYield.makeCoYield(co, instructionsCount)
	return createIronBoxObject(co, env)
end

return IronBox