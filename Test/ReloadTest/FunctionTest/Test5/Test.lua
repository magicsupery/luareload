local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.FunctionTest.Test5."
local r = {
    prefix .. "MyFunction",
}

local Lambda = require(prefix .. "Lambda")

Lambda.lambda()
class.setReload(true)
reload.reload(r)
class.setReload(false)


Lambda.lambda()
class.setReload(true)
reload.reload(r)
class.setReload(false)

Lambda.lambda()

