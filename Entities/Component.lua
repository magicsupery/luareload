local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")
function BattleComponent:ctor()
    print("BattleComponent:ctor old")
end

return BattleComponent
