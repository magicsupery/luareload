local module = {

}

local a = 1

function module.print(num)
    print("print old ", num)
end

function module.handler()
    local function triggerHandler()
        module.print(a)
    end

    triggerHandler()
end
return module