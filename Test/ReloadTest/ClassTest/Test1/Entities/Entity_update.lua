local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

function Entity:ctor() 
    print("ctor new")
end

function Entity:replace() 
    print("replace new")
end

function Entity:add()
    print("add new")
end



return Entity