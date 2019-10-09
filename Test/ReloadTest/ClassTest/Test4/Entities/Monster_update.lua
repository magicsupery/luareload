local class = require("Core.Framework.Class")
local prefix = "Test.ReloadTest.ClassTest.Test4."
local Entity = require(prefix .. "Entities.Entity")
local Monster = class.Class("Monster", Entity)

function Monster:ctor() 
    Monster.super.ctor(self)
    print("Monster:ctor new")
end

function Monster:monster()
    print("Monster:monster new")
end

return Monster