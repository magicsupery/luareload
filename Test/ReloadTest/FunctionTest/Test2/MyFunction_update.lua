local module = {

}

local prefix = "Test.ReloadTest.FunctionTest.Test2."
local a = 10
local b = 20
local c = require(prefix .. "NewModule")
local d = require(prefix .. "NewModule")

function module.upvalues()
    print("upvalues new", a, b, c.test(), d.test())
end

return module