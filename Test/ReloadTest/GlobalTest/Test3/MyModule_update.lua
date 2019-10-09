local a = 10
local b = CS.mgr
local data = {
    a = a,
    c = CS.mgr,
}

function data.testCS()
    print("b is ", b)
end

return data