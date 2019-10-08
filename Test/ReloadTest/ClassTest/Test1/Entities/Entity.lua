local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

function Entity:ctor() 
    print("ctor old")
end

function Entity:replace() 
    print("replace old")
end

function Entity:remove()
    print("remove old")
end

return Entity