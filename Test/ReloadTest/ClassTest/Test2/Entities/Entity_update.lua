local class = require("Core.Framework.Class")

local Entity = class.Class("Entity")

local prefix = "Test.ReloadTest.ClassTest.Test2."
local BattleComponent = require(prefix .. "Entities.BattleComponent")
local StateComponent = require(prefix .. "Entities.StateComponent") 
class.AddComponents(Entity, {BattleComponent, StateComponent})

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