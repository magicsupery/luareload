local prefix = "Test.ReloadTest.FunctionTest.Test5."
local MyFunction = require(prefix .. "MyFunction")

local module = {
    
}

function module.lambda() 
    MyFunction.dosth()
end

return module