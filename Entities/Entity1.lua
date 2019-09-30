local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")
function BattleComponent:ctor()
    print("BattleComponent:ctor old")
end

local BattleComponent2 = class.Component("BattleComponent2")
function BattleComponent:ctor()
    print("BattleComponent2:ctor old")
end
local EntityComponents = {
    BattleComponent,
    BattleComponent2,
}
local Entity = class.Class("Entity")
class.AddComponents(Entity, EntityComponents)

function Entity:ctor()
    print("Entity:ctor old")
end

function Entity:do1() 
    print("do1 old")
end

function Entity:do2() 
    print("do2 old")
end

function Entity:_do()
    print("_do old")
end
return Entity