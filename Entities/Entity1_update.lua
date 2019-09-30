local class = require("Core.Framework.Class")
local Monster = require("Entities.Entity2")
local try = require("Core.Framework.Exception")
local Entity = class.Class("Entity")
local BattleComponent = require("Entities.Component")

local EntityComponents = {
    BattleComponent,
}

local Entity = class.Class("Entity")
class.AddComponents(Entity, EntityComponents)

function Entity:ctor() 
    print("try is ", try)
    print("Entity:ctor new")
    print(class.isInstanceOf)
    Monster:do1()
end

function Entity:do2()
    print(class.isInstanceOf)
    Monster:do1()
    self:_do()
    print("entity do2 new")
end

function Entity:do1()
    try(function()
        print ("entity do1 new")
    end).
    catch(function(ex)
    end)

end
--[[Entity



function Entity:ctor() 
    print "new ctor"
end
]]
return Entity