local reload = require "reload"
reload.postfix = "_update"	-- for test

local mymod = require "mymod"

function reload.print(...)
	print("  DEBUG:", ...)
end

mymod.foobar(42)

local tmp = {}

local foo = mymod.foo2()
tmp[foo] = foo
print("FOO before", foo)

local obj = mymod.new()

obj:show()

function test()
	print("BEFORE update foo", foo)
	reload.reload { "yc" }
	print("AFTER update foo", foo)
end

test()
print ("call foo() ret ", foo())

print("FOO after", foo)
assert(tmp[foo] == foo)

obj:show()

mymod.foo4()
print ("foo3 ret is ", mymod.foo3())