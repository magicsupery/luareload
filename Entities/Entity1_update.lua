print("do reload entity 1")
local class = require("Core.Framework.Class")
print("class is ", class)
local Entity = class.Class("Entity")

function Entity:do1() 
    print("do1 new")
end

return Entity