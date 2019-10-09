local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test7."
local Monster = require(prefix .. "Entities.Monster")
local Boss = class.Class("Boss", Monster)

function Boss:ctor() 
    Boss.super.ctor(self)
    print("Boss:ctor new")
end

function Boss:attack()
    Boss.super.attack(self)
    print("Boss:attack new")
end


return Boss