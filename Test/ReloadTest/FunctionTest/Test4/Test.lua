local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print


-- reload env
local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.FunctionTest.Test4."
local r = {
    prefix .. "MyFunction",
}

local MyFunction = require(prefix .. "MyFunction")


local localHandler = MyFunction.createHandler()

print("oldHandler start")
localHandler() -- 只能变更触发的函数内容，handler本身是无法改变了
print("oldHandler end")

class.setReload(true)
reload.reload(r)
class.setReload(false)

local newHandler = MyFunction.createHandler()

print("oldHandler start")
localHandler()
print("oldHandler end")
newHandler()

class.setReload(true)
reload.reload(r)
class.setReload(false)

print("oldHandler start")
localHandler()
print("oldHandler end")
newHandler()
