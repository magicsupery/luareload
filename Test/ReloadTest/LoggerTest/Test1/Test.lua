local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print

local LoggerManager = require("Core.Log.LoggerManager")

reload.initEnv({
    loggerGenerateFunc = LoggerManager.getLogger ,
})

-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.LoggerTest.Test1."
local r = {
    prefix .. "MyModule",
}

local MyModule = require(prefix .. "MyModule")

MyModule:testLogger()
class.setReload(true)
reload.reload(r)
class.setReload(false)

MyModule:testLogger()
MyModule:testLoggerUpdate()
