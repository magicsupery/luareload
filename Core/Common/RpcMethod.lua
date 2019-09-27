local LoggerManager = require ("Core.Log.LoggerManager")
local class = require ("Core.Framework.Class")
local logger = LoggerManager.getLogger("RpcMethod")

local RpcMethod = class.Class("RpcMethod")


function RpcMethod:ctor(accessor, args, func, name) 
    self.accessor = accessor
    self.args = args
    self.func = func
    self.name = name

    local meta = getmetatable(self)
    meta.__call = RpcMethod.call
    setmetatable(self, meta)

end


function RpcMethod:call(callerAccessor, obj, ...)
    if self.accessor ~= callerAccessor then 
        logger:error("RpcMethod %s need accessor %d, but got %d", self.name, self.accessor, callerAccessor)
        return
    end

    local num = select("#", ...)
    if num ~= #self.args then
        logger:error("RpcMethod %s need args num %d, but got %d", self.name, #self.args, num)
        return
    end
    for i = 1, num do
        local arg = select(i, ...)
        if type(arg) ~= self.args[i] then
            logger:error("RpcMethod %s need args %d type %s, but got %s", self.name, i, self.args[i], type(arg))
            return
        end
    end

    self.func(obj, ...)

end

return RpcMethod