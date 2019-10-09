
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test5."
local r = {
     prefix .. "Entities.Boss",
}


local Boss = require(prefix .. "Entities.Boss")

local boss = Boss()
boss:attack()

class.setReload(true)
reload.reload(r)
class.setReload(false)

boss:attack()
print("==========================")
local newBoss = Boss()
newBoss:attack()


class.setReload(true)
reload.reload(r)
class.setReload(false)

boss:attack()
print("==========================")
local newBoss = Boss()
newBoss:attack()