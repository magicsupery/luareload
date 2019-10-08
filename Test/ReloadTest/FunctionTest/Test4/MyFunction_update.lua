local module = {

}

local a = 10

function module.print(num)
    print("print new", num)
end

function module.createHandler()
    local function handler()
        module.print(a)
        module.print(a)
    end

    return handler
end

return module