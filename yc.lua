local debug = require "debug"

local mod = {}

local a = 2
local b = 10
local function foobar()
	print "OLD"
	return a, mod
end

function mod.foo3()
	local function tmp()
	end
	return tmp()
end

return mod