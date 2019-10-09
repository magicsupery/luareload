
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test3."
local r = {
    prefix .. "Entities.Monster",
}


local Monster = require(prefix .. "Entities.Monster")

local monster = Monster()

monster:monster()

class.setReload(true)
reload.reload(r)
class.setReload(false)

monster:monster()
print("==========================")
local newMon = Monster()
newMon:monster()


class.setReload(true)
reload.reload(r)
class.setReload(false)

monster:monster()
print("==========================")
local newMon = Monster()
newMon:monster()