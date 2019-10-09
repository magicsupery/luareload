local class = require("Core.Framework.Class")

local BattleComponent = class.Component("BattleComponent")

function BattleComponent:ctor()
    print("BattleComponent:ctor old")
end

function BattleComponent:battle()
    print("BattleComponent:battle old")
end

return BattleComponent