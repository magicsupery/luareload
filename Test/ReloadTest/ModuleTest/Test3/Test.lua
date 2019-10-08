local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ModuleTest.Test3."
local r = {
    prefix .. "MyModule",
}

require(prefix .. "Ref")
local MyModule = require(prefix .. "MyModule")

print("old value ", MyModule.replace(), MyModule.remove())
class.setReload(true)
reload.reload(r)
class.setReload(false)


print("new value ", MyModule.replace(), MyModule.add(), MyModule.remove())
class.setReload(true)
reload.reload(r)
class.setReload(false)

print("new value ", MyModule.replace(), MyModule.add(), MyModule.remove())

