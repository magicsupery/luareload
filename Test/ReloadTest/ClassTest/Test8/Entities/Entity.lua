local class = require("Core.Framework.Class")


local Entity = class.Class("Entity")

local prefix = "Test.ReloadTest.ClassTest.Test8."
local StateComponent = require(prefix .. "Entities.StateComponent")
class.AddComponent(Entity, StateComponent)

function Entity:ctor()
    print("Entity:ctor old")
end

function Entity:entity()
    print("Entity:entity old")
end

function Entity:specialEntity()
    print("Entity:specialEntity old")
end

function Entity:attack()
    print("Entity:attack old")
end

return Entity