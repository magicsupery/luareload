local lfs = require ("lfs")
local RpcMethod = require ("Core.Common.RpcMethod")
local Const = require ("Core.Common.Const")

local LoggerManager = require ("Core.Log.LoggerManager")

local logger = LoggerManager.getLogger("EntityFactory")
local EntityFactory = {
    _entities = {},

}

function EntityFactory.hasClass(name)
    return EntityFactory._entities[name] ~= nil
end

function EntityFactory._registerEntity(name, entity)
    EntityFactory._entities[name] = entity
end

function EntityFactory.createEntity(name, entityid)
    if EntityFactory._entities[name] == nil then
        logger:error("can not find entity %s", name)
        return nil
    end

    return EntityFactory._entities[name](entityid)

end

function EntityFactory.parseConfig(rootPath)
    local methodRegister = {}

    for file in lfs.dir(rootPath) do
        if file ~= "." and file ~= ".." and string.sub(file, -4) == ".lua" then
            local path = rootPath .. "/" .. file
            local data = dofile(path)
            local namespace = data["NameSpace"]
            if namespace == nil then
                error("Config " .. file .. " get invalid namespace " .. namespace)
            end

            local name = data["Class"]
            if name == nil or type(name) ~= "string" then
                error("Config " .. file .. " get invalid name " .. name)
            end
            if EntityFactory.hasClass(name) then
                error("Config " .. file .. " get repeat class " .. name)
            end
            
            logger:info("start parse namespace %s with class %s ", namespace, name)
            local entity = require (namespace)
            entity.__CLASS_NAME__ = name

            --check method valid
            EntityFactory._parseMethod(entity, data, Const.ACCESSOR_CLIENT, methodRegister)
            EntityFactory._parseMethod(entity, data, Const.ACCESSOR_SERVER, methodRegister)
            
            EntityFactory._registerEntity(name, entity)
            end

    --Todo Check method names unique  methodsRegister
    end
end

function EntityFactory._parseMethod(entity, data, methodType, methodRegister)
    local methodTypeStr = Const.ACCESSOR_INT_TO_STRING[methodType]
    local methods = data[methodTypeStr]
    if methods == nil then
        return
    end

    for k, v in pairs (methods) do
        if methodRegister[k] ~= nil then
            error("entity " .. entity.__CLASS_NAME__ .. " register dup method " .. k)
        end

        local func = entity[k]
        if func == nil then
            error("entity " .. entity.__CLASS_NAME__ .. " has no function " .. k)
        end

        if type(func) ~= "function" then
            error("entity " .. entity.__CLASS_NAME__ .. " has wrong type " .. k)
        end
        
        for i = 1, #v do
            if Const.ARG_TYPE_NUMBER[v[i]] ~= nil then
                v[i] = "number"
            end
        end
        entity:forceAttrRepeat(k)
        entity[k] = RpcMethod(methodType, v, func, k)
        

        methodRegister[k] = true
    end
end

return EntityFactory