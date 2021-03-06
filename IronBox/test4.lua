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

local IronBox = require "IronBox"

isPrime = IronBox.create(function(x)
	if x < 2 then return false end
	if x % 2 == 0 then return false end
	local i
	for i=3,x/2,2 do
		if x % 3 == 0 then return false end
	end
	return true
end)

print(isPrime(17)) -- first arg is the status and the rest are the return values from the function
print(isPrime(18)) -- does not work because the coroutine has already quit

-- so we reset it (the environment of the box is not touched so variables stay the same value)
isPrime:reset()

print(isPrime(18))

isPrime:reset()
print(isPrime(100123456789))  -- this is actually a prime
-- But it takes too long to finish because isPrime is slow and was made in a hurry for demonstration :P

-- We can reset it even though the coroutine is paused
isPrime:reset()
print(isPrime(997))
