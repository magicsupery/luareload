local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

function Entity:ctor()
    print("Entity:ctor new")
end

function Entity:entity()
    print("Entity:entity new")
end

function Entity:specialEntity()
    print("Entity:specialEntity new")
end

function Entity:attack()
    print("Entity:attack new")
end

return Entity