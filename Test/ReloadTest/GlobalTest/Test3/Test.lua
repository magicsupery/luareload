local GLDeclare= require("Core.Framework.Global")

GLDeclare("CS", {mgr = {}, })

local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.GlobalTest.Test3."
local r = {
    prefix .. "MyModule",
}

local MyModule = require(prefix .. "MyModule")

print ("MyModule c ", MyModule.c)
class.setReload(true)
reload.reload(r)
class.setReload(false)

print ("MyModule c ", MyModule.c)
MyModule.testCS()
