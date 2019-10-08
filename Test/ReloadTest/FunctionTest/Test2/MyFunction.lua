local module = {

}

local prefix = "Test.ReloadTest.FunctionTest.Test2."
local a = 1
local b = 2
local c = require(prefix .. "OldModule")

function module.upvalues()
    print("upvalues old ", a, b, c.test())
end

return module