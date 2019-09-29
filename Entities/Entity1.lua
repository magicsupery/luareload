local class = require("Core.Framework.Class")
local Monster = require("Entities.Entity2")
local Entity = class.Class("Entity")

function Entity:do1() 
    print("do1 old")
end

function Entity:_do()
    print("_do old")
end
return Entity