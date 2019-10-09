local a = 10
local data = {
    a = a,
    c = c,
}

function data.globalTest()
    print("c is ", c)
end

return data