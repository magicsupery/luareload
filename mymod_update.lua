local debug = require "debug"

local mod = {}

local a = 2

local function foobar()
	print "UPDATE"
	return a
end

print("update foobar:", foobar)

function mod.foo()
	return foobar()
end

function mod.foo2()
	return foobar
end

function mod.foo4()
	print("foo4 a is ", a)
end

function mod.foobar(x)
	a = x
end

mod.getinfo = debug.getinfo

local meta = {}

meta.__index = meta

function meta:show()
	print("NEW")
end

function mod.new()
	return setmetatable({}, meta)
end

return mod