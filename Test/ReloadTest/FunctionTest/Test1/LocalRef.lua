local prefix = "Test.ReloadTest.FunctionTest.Test1."
local MyFunction = require(prefix .. "MyFunction")

local module = {
    localRef = MyFunction.localRef,
}

return module