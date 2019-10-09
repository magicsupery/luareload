local class = require("Core.Framework.Class")

local StateComponent = class.Component("StateComponent")

function StateComponent:ctor()
    print("StateComponent:ctor new")
end

function StateComponent:state()
    print("StateComponent:state new")
end

return StateComponent