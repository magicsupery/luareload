local GLDeclare= require("Core.Framework.Global")

GLDeclare("c", 100)

local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.GlobalTest.Test2."
local r = {
    prefix .. "MyModule",
}

local MyModule = require(prefix .. "MyModule")

class.setReload(true)
reload.reload(r)
class.setReload(false)

MyModule.globalTest()