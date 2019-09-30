local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")
function BattleComponent:ctor()
    print("BattleComponent:ctor new")
end

return BattleComponent
