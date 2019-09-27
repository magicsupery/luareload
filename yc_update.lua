local debug = require "debug"

local mod = {}

local a = 30
local b = 10
local function foobar()
	print "NEW"
	return a
end

function mod.foo1()
end
function mod.foo3()
	local function tmp()
		print("new tmp ", mod.foo1)
		return foobar()
	end
	return tmp()
end

return mod