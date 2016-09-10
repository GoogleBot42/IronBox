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

-- this table is not safe to be exposed to a sandbox
local IronBoxes = setmetatable({}, { __mode = "kv" })

local function table_combine(t1, t2)
	for i, v in pairs(t2) do
		t1[i] = v
	end
end

local function default_errorfunc(msg, box)
	if box then
		print("Error in IronBox [" .. tostring(box.id) .. "]: " .. msg)
	else
		print("Error could not create new box: " .. msg)
	end
end

local IronBox__meta = {
	__call = function(box, ...)
		return box:resume(...)
	end,
	
	__index = {
		resume = function(box, ...)
			if type(box.co) == "thread" then
				-- also pass box for error handler
				CoYield.resume(box.co, box, ...)
				box.timesRun = box.timesRun + 1
			end
		end,
	},
}

local function createIronBoxObject(co, env, errorFunc)
	if co then
		local box = {
			co = co, 
			env = env,
			id = #IronBoxes + 1,
			errorFunc = errorFunc,
			timesRun = 0,
		}
		table.insert(IronBoxes, box)
		return setmetatable(box, IronBox__meta)
	else
		return setmetatable({ }, IronBox__meta) -- return empty object: failed
	end
end

function IronBox.create(untrusted, env, errorfunc)
	-- type checks
	assert(type(untrusted) == "string" or type(untrusted) == "function")
	assert(errorfunc == nil or type(errorfunc) == "function")
	
	-- set error function
	errorfunc = errorfunc or default_errorfunc
	if jit then jit.off(errorfunc,true) end -- make sure everything is not jit compiled and will respond to yeild
	
	-- extract options and create environment
	local instructionsCount
	if env then
		if env._combineEnvWithDefault then
			table_combine(env, envGen())
		end
		if type(env._count) == "number" then
			instructionsCount = env._count
		end
	else
		env = envGen()
	end
	
	-- get function from string if necessary
	if type(untrusted) == 'string' then
		local msg
		untrusted, msg = loadstring(untrusted)
		if untrusted == nil then
			errorfunc(msg)
			return nil -- failed to create a box
		end
	end
	
	-- set environment
	setfenv(untrusted,env)
	
	-- create safe wrapper function
	local safefunc = function(box, ...)
		local ok, result = pcall(untrusted, ...)
		if not ok then
			box.errorFunc(result, box)
		end
		return result
	end
	
	-- untrusted code cannot be jit compiled and guarantee that it will yeild
	if jit then jit.off(untrusted,true) end
	if jit then jit.off(safefunc,true) end
	
	-- create safe coroutine
	local co = coroutine.create(safefunc)
	CoYield.makeCoYield(co, instructionsCount)
	return createIronBoxObject(co, env, errorfunc)
end

return IronBox
