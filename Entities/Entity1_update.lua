local class = require("Core.Framework.Class")
local Monster = require("Entities.Entity2")
local Entity = class.Class("Entity")

function Entity:do1()
    print ("entity do1 new")
end

function Entity:do2()
    print(class.isInstanceOf)
    Monster:do1()
    self:_do()
    print("entity do2 new")
end

return Entity