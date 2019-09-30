local class = require("Core.Framework.Class")
local try = require("Core.Framework.Exception")
local BattleComponent = require("Entities.Component")
local EntityComponents = {
    BattleComponent,
}
local Entity = class.Class("Entity")
class.AddComponents(Entity, EntityComponents)

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