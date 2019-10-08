local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.FunctionTest.Test2."
local r = {
    prefix .. "MyFunction",
    prefix .. "NewModule",
}

require(prefix .. "NewModule")
local MyFunction = require(prefix .. "MyFunction")

MyFunction.upvalues()
class.setReload(true)
reload.reload(r)
class.setReload(false)


MyFunction.upvalues()
class.setReload(true)
reload.reload(r)
class.setReload(false)

MyFunction.upvalues()

