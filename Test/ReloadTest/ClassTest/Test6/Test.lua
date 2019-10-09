
local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test6."
local r = {
     prefix .. "Entities.Boss",
}


local Boss = require(prefix .. "Entities.Boss")

local boss = Boss()

boss:attack()
boss:entity()

class.setReload(true)
reload.reload(r)
class.setReload(false)

boss:attack()
boss:entity()
print("==========================")
local newBoss = Boss()
newBoss:attack()
newBoss:entity()

