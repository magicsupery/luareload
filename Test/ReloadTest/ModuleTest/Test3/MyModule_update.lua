local prefix = "Test.ReloadTest.ModuleTest.Test3."
local Ref = require(prefix .. "Ref")
local module = {
}

function module.replace()
    print("replace new")
end

function module.add()
    print("add new")
    Ref.ref()
end

return module
