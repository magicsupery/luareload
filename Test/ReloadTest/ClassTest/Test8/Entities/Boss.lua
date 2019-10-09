local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test8."
local Monster = require(prefix .. "Entities.Monster")
local Boss = class.Class("Boss", Monster)

function Boss:ctor() 
    Boss.super.ctor(self)
    print("Boss:ctor old")
end

function Boss:attack()
    Boss.super.attack(self)
    print("Boss:attack old")
end

function Boss:boss()
    print("Boss:boss old")
end

function Boss:entity()
    Boss.super.entity(self)
end

return Boss