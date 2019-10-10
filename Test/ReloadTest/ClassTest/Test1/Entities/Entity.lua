local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

local a = 1
function Entity:ctor() 
    print("ctor old")
end

function Entity:replace() 
    print("a is ", a)
    print("replace old")
end

function Entity:remove()
    print("remove old")
end

return Entity