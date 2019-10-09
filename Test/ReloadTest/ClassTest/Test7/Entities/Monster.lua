local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test7."
local Entity = require(prefix .. "Entities.Entity")
local Monster = class.Class("Monster", Entity)

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