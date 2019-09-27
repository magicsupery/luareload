-- Global.lua
-- 辅助记录全局变量的名称是否被使用过
local _GlobalNames = { }

local _SystemUsedNames = {
    socket = 1,
}
local function __innerDeclare(name, defaultValue, override)
    if not rawget(_G, name) then
        rawset(_G, name, defaultValue or false)
    elseif override then
        rawset(_G, name, defaultValue or false)
    else
        print("[Warning] The global variable " .. name .. " is already declared!")
    end
    _GlobalNames[name] = true
    return _G[name]
end

local function __innerDeclareIndex(tbl, key)
    if not _GlobalNames[key] then
        print("Attempt to access an undeclared global variable : " .. key)
        error("Attempt to access an undeclared global variable : " .. key)
    end

    return nil
end

local function __innerDeclareNewindex(tbl, key, value)
    if not _GlobalNames[key] and not _SystemUsedNames[key] then
        print("Attempt to write an undeclared global variable : " .. key)
        error("Attempt to write an undeclared global variable : " .. key)
    else
        rawset(tbl, key, value)
    end
end

local function __GLDeclare(name, defaultValue, override)
    local ok, ret = pcall(__innerDeclare, name, defaultValue, override)
    if not ok then
        error(debug.traceback(res, 2))
        return nil
    else
        return ret
    end
end

local function __isGLDeclared(name)
    if _GlobalNames[name] or rawget(_G, name) then
        return true
    else
        return false
    end
end

-- Set "GLDeclare" into global.
if (not __isGLDeclared("GLDeclare")) or (not GLDeclare) then
    __GLDeclare("GLDeclare", __GLDeclare)
end

-- Set "IsGLDeclared" into global.
if (not __isGLDeclared("IsGLDeclared")) or(not IsGLDeclared) then
    __GLDeclare("IsGLDeclared", __isGLDeclared)
end

setmetatable(_G,
{
    __index = function(tbl, key)
        local ok, res = pcall(__innerDeclareIndex, tbl, key)
        if not ok then
            print(debug.traceback())
        end

        return nil
    end,

    __newindex = function(tbl, key, value)
        local ok, res = pcall(__innerDeclareNewindex, tbl, key, value)
        if not ok then
            print(debug.traceback())
        end
    end
} )

return __GLDeclare