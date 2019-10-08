local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.FunctionTest.Test3."
local r = {
    prefix .. "MyFunction",
}

local MyFunction = require(prefix .. "MyFunction")


MyFunction.handler()
class.setReload(true)
reload.reload(r)
class.setReload(false)

MyFunction.handler()

class.setReload(true)
reload.reload(r)
class.setReload(false)

MyFunction.handler()

