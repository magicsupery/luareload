
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test1."
local r = {
    prefix .. "Entities.Entity",
}


local Entity = require(prefix .. "Entities.Entity")

local ent = Entity()

ent:replace()
ent:remove()
ent:destroy()

class.setReload(true)
reload.reload(r)
class.setReload(false)

ent:replace()
ent:remove()
ent:add()
ent:destroy()
print("==========================")
local newEnt = Entity()

newEnt:replace()
newEnt:remove()
newEnt:add()
newEnt:destroy()

class.setReload(true)
reload.reload(r)
class.setReload(false)

ent:replace()
ent:remove()
ent:add()
ent:destroy()
print("==========================")
local newEnt = Entity()

newEnt:replace()
newEnt:remove()
newEnt:add()
newEnt:destroy()