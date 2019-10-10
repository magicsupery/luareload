
local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test4."
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
newMon:entity()


class.setReload(true)
reload.reload(r)
class.setReload(false)

monster:monster()
print("==========================")
local newMon = Monster()
newMon:monster()
newMon:entity()