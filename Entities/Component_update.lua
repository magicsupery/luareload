local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")
function BattleComponent:ctor()
    print("BattleComponent:ctor new")
end

print ("in file ", BattleComponent, BattleComponent.typeName, BattleComponent.__IsComponent)
return BattleComponent
