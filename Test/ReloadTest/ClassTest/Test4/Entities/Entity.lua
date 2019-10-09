local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

function Entity:ctor()
    print("Entity:ctor old")
end

function Entity:entity()
    print("Entity:entity old")
end

return Entity