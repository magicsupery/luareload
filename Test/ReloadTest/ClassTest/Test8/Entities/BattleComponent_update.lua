local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")

function BattleComponent:ctor() 
    print("BattleComponent:ctor new")
end

function BattleComponent:battle()
    print("BattleComponent:battle new")
end

function BattleComponent:destroy()
    print("BattleComponent:destroy new")
end

function BattleComponent:crash()
    print("BattleComponent:crash new")
end

return BattleComponent