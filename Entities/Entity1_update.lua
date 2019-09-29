local class = require("Core.Framework.Class")
local Monster = require("Entities.Entity2")
local Entity = class.Class("Entity")
function Entity:do1() 
    Monster:do1()
    print("entity do1 new")
end

function Entity:do2()
    Monster:do1()
    print("entity do2 new")
end
return Entity