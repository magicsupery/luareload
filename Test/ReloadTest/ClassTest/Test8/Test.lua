
local reload = require("Core.Framework.Reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test8."
local r = {
     prefix .. "Entities.Boss",
     prefix .. "Entities.Entity",
     prefix .. "Entities.BattleComponent",
     prefix .. "Entities.StateComponent",
}


local Boss = require(prefix .. "Entities.Boss")

local boss = Boss()

boss:attack()
boss:monster()
boss:entity()
boss:specialEntity()
boss:battle()
boss:state()

class.setReload(true)
reload.reload(r)
class.setReload(false)
boss:attack()
boss:monster()
boss:entity()
boss:specialEntity()
boss:battle()
boss:state()
print("==========================")
local newBoss = Boss()
newBoss:attack()
newBoss:monster()
newBoss:entity()
newBoss:specialEntity()
newBoss:battle()
newBoss:state()

