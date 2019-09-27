-- Reload.lua
-- 并没有给出完整代码，仅供参考
local Reload = {
    _ImportModule = {},
    postfix = ""
}

local function findLoader(name)
	if Reload.postfix then
		name = name .. Reload.postfix
	end
	local msg = {}
	for _, loader in ipairs(package.loaders) do
		local f , extra = loader(name)
		local t = type(f)
		if t == "function" then
			return f, extra
		elseif t == "string" then
			table.insert(msg, f)
		end
	end
	error(string.format("module '%s' not found:%s", name, table.concat(msg)))
end

function Reload.reload(pathfiles)
    for _, pathfile in ipairs(pathfiles) do
        local _LOADED = debug.getregistry()._LOADED
        local old = _LOADED[pathfile]

        local loader, arg = findLoader(pathfile)
        local new = loader(realFile, arg)

        -- 将新的覆盖到旧的
        for k,v in pairs(New) do

        end
    end
end

return Reload