local module = {

}

local a = 1

function module.print(num)
    print("print old ", num)
end

function module.createHandler()
    local function handler()
        module.print(a)
    end

    return handler
end

return module