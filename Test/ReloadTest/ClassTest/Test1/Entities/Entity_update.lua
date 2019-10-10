local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

local a = 10
function Entity:ctor() 
    print("ctor new")
end

function Entity:replace() 
    print("Entity is ", Entity)
    print("a is ", a)
    a = 2
    print("replace new")
end

function Entity:add()
    print("Entity is ", Entity)
    print("add new")
end



return Entity