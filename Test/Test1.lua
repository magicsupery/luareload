
local reload = require("Core.Framework.reload")
reload.postfix = "_update"	-- for test
reload.print = print

local Entity = require("Entities.Entity1")

local ent = Entity()

ent:do1()

-- reload env
local class = require("Core.Framework.Class")
class.setReload(true)
reload.reload({"Entities.Entity2", "Entities.Entity1"})
class.setReload(false)


local newEnt = Entity()

ent:do2()
ent:do1()