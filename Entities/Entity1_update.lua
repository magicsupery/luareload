local class = require("Core.Framework.Class")
local Monster = require("Entities.Entity2")
local Entity = class.Class("Entity")

function Entity:do2()
    Monster:do1()
    self:_do()
    print(class.isInstanceOf)
    print("entity do2 new")
end

return Entity