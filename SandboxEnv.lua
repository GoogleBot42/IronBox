return function() return {
	assert = assert,
	-- dofile
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
	-- yield = coroutine.yield, make sure that no c boundaries are surpassed or lua will terminate
	},
	-- module
	-- require
	-- package.*
	string = {
		byte = string.byte,
		char = string.char,
		-- dump = string.dump

		-- Determine if these are safe
		--   string.find -- warning: a number of functions like this can still lock up the CPU [6]
		--   string.format
		--   string.gmatch
		--   string.gsub
		--   string.match
		--   string.sub

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
		randomseed = math.randomseed,
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
