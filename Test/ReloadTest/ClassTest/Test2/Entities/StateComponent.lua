local class = require("Core.Framework.Class")

local StateComponent = class.Component("StateComponent")

function StateComponent:ctor()
    print("StateComponent:ctor old")
end

function StateComponent:state()
    print("StateComponent:state old")
end

return StateComponent