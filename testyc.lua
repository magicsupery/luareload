local reload = require "reload"
reload.postfix = "_update"	-- for test

local yc = require "yc"

function reload.print(...)
	print("  DEBUG:", ...)
end

local func = yc.foo3
function test()
	reload.reload { "yc" }
end

test()
print (func())
print (yc.foo3())
