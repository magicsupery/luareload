local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test8."
local Entity = require(prefix .. "Entities.Entity")
local Monster = class.Class("Monster", Entity)

local BattleComponent = require(prefix .. "Entities.BattleComponent")
class.AddComponent(Monster, BattleComponent)
function Monster:ctor()
    Monster.super.ctor(self)
    print("Monster:ctor old")
end

function Monster:attack()
    Monster.super.attack(self)
    print("Monster:attack old")
end

function Monster:monster()
    print("Monster:monster old")
end

return Monster