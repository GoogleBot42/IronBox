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

local function error_hand(msg, box) -- "msg" holds the error. "box" is the ironbox that had the error.
    print("There was an error!")
end

-- use default environment with custom error handler
-- error_hand is called: syntax error
local box1 = IronBox.create("while true do", nil, error_hand)

-- empty environment and default error handler (this just prints error to console)
-- print has not been exposed to this IronBox.  But this box hasn't run yet so no error
local box2 = IronBox.create(function() print("test") end, {})

if box1 then -- IronBox.create returns nil if unsuccessful
	box1()
	print("box1 creation successful")
end

box2() -- error msg is sent to default error handler which prints error to console


