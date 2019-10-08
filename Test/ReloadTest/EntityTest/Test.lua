
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local Entity = require("Entities.Entity1")

print(Entity._IsSingleton, Entity.__IsClass, Entity.typeName)
local ent = Entity()

ent:do1()

-- reload env
local class = require("Core.Framework.Class")
local r = {
    "Entities.Component",
    "Entities.Entity1",
    "Entities.Entity2",
}
class.setReload(true)
reload.reload(r)
class.setReload(false)

print(Entity._IsSingleton, Entity.__IsClass, Entity.typeName)

ent:do2()
ent:do1()

local newEnt = Entity()

class.setReload(true)
reload.reload(r)
class.setReload(false)

local newEnt = Entity()