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



---------------------------------------------------------------------
-- environment variables that have been commented out are not safe --
-- but a few of them could potentially be made safe                --
---------------------------------------------------------------------

return function() return {
	assert = assert,
	-- dofile = dofile,
	error = error,
	ipairs = ipairs,
	next = next,
	pairs = pairs,
	pcall = pcall,
	print = print,
	rawequal = rawequal,
	select = select,
	tonumber = tonumber,
	tostring = tostring,
	type = type,
	unpack = unpack,
	_VERSION = _VERSION,
	xpcall = xpcall,
	coroutine = {
	create = coroutine.create,
	resume = coroutine.resume,
	running = coroutine.running,
	status = coroutine.status,
	wrap = coroutine.wrap,
	-- yield = coroutine.yield, -- make sure that no c boundaries are surpassed or lua will terminate with an error
	},
	-- module = module,
	-- require = module,
	-- package.*
	string = {
		byte = string.byte,
		char = string.char,
		-- dump = string.dump,

		-- TODO: Determine if these are safe and/or write lua implementations
		-- find = string.find, -- warning: a number of functions like this can still lock up the CPU [6]
		-- format = string.format,
		-- gmatch = string.gmatch,
		-- gsub = string.gsub,
		-- match = string.match,
		-- sub = string.sub,

		len = string.len,
		lower = string.lower,
		rep = string.rep,
		reverse = string.reverse,
		upper = string.upper,
	},
	table = {
		insert = table.insert,
		maxn = table.maxn,
		remove = table.remove,
		sort = table.sort,
	},
	math = {
		abs = math.abs,
		acos = math.acos,
		asin = math.asin,
		atan = math.atan,
		atan2 = math.atan2,
		ceil = math.ceil,
		cos = math.cos,
		cosh = math.cosh,
		deg = math.deg,
		exp = math.exp,
		floor = math.floor,
		fmod = math.fmod,
		frexp = math.frexp,
		huge = math.huge,
		ldexp = math.ldexp,
		log = math.log,
		log10 = math.log10,
		max = math.max,
		min = math.min,
		modf = math.modf,
		pi = math.pi,
		pow = math.pow,
		rad = math.rad,
		random = math.random,
		-- randomseed = math.randomseed,
		sin = math.sin,
		sinh = math.sinh,
		sqrt = math.sqrt,
		tan = math.tan,
		tanh = math.tanh,
	},
	-- io.*
	os = {
		clock = os.clock,
		difftime = os.difftime,
		time = os.time,
	},
} end
