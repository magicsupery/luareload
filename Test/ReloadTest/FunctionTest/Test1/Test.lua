local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.FunctionTest.Test1."
local r = {
    prefix .. "MyFunction",
}

local LocalRef = require(prefix .. "LocalRef")

LocalRef.localRef()
class.setReload(true)
reload.reload(r)
class.setReload(false)


LocalRef.localRef()
class.setReload(true)
reload.reload(r)
class.setReload(false)

LocalRef.localRef()

