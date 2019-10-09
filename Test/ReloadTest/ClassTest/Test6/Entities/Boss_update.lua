local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test6."
local Monster = require(prefix .. "Entities.Monster")
local Boss = class.Class("Boss", Monster)

function Boss:ctor() 
    Boss.super.ctor(self)
    print("Boss:ctor new")
end

function Boss:attack()
    print("Boss:attack new")
end

function Boss:entity()
    Boss.super.entity(self)
    print("Boss:entity new")
end


return Boss