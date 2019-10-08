local module = {

}

local a = 10

function module.print(num)
    print("print new", num)
end

function module.handler()
    local function triggerHandler()
        module.print(a)
        module.print(a)
    end

    triggerHandler()
end

return module