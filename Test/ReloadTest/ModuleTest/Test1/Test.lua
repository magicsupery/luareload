local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ModuleTest.Test1."
local r = {
    prefix .. "MyModule",
}

local MyModule = require(prefix .. "MyModule")

print("old value ", MyModule["1"], MyModule.a, MyModule.b, MyModule.c)
class.setReload(true)
reload.reload(r)
class.setReload(false)


print("new value ", MyModule["1"], MyModule.a, MyModule.b, MyModule.c)
class.setReload(true)
reload.reload(r)
class.setReload(false)


print("new value ", MyModule["1"], MyModule.a, MyModule.b, MyModule.c)
