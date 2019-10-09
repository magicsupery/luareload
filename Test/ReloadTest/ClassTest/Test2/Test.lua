
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test2."
local r = {
    prefix .. "Entities.Entity",
    prefix .. "Entities.BattleComponent",
    --prefix .. "Entities.StateComponent",
}


local Entity = require(prefix .. "Entities.Entity")

local ent = Entity()

ent:battle()
ent:state()
ent:destroy()

class.setReload(true)
reload.reload(r)
class.setReload(false)

ent:battle()
ent:state()
ent:destroy()
print("==========================")
local newEnt = Entity()
newEnt:state()
newEnt:battle()
newEnt:destroy()
newEnt:crash()

class.setReload(true)
reload.reload(r)
class.setReload(false)

ent:battle()
ent:state()
ent:destroy()
print("==========================")
local newEnt = Entity()
newEnt:state()
newEnt:battle()
newEnt:destroy()
newEnt:crash()