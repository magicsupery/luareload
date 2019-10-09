local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test6."
local Monster = require(prefix .. "Entities.Monster")
local Boss = class.Class("Boss", Monster)

function Boss:ctor() 
    Boss.super.ctor(self)
    print("Boss:ctor old")
end

function Boss:attack()
    print("Boss:attack old")
end

return Boss