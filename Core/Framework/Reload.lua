local reload = {}
local sandbox = {}

local table = table
local debug = debug

do -- sandbox begin

local dummy_cache = {}
local dummy_module_cache = {}

-- wrapperStart
local __defaultMethods = {
		ctor = true,
		init = true,
		start = true,
		stop = true,
		destroy = true,
}

function sandbox.isDefaultMethods(key)
	return __defaultMethods[key]
end

local classWrapper = {
	class = {},

}
function classWrapper.Class(name, super, isSingleton)
	local newClass = {
			__IsClass = true,
			typeName = name,
			superType = classWrapper.GenerateClass(super),
			_IsSingleton = isSingleton or false,
			components = {},
	}

	classWrapper.class[newClass] = newClass
	classWrapper.class[name] = newClass
	return newClass
end

function classWrapper.Component(name)
	local newComponent = {
		__IsComponent = true,
		typeName = name,	
	}

	return newComponent
end

function classWrapper.GenerateClass(cls)
	if getmetatable(cls) ~= nil then
		local k = dummy_module_cache[cls]
		--非dummy，是真实的class, 解决ClassTest-Test5的问题，继承链上传过来的superType不是dummy，是realClass.superType
		if k == nil then
			cls = classWrapper.Class(cls.typeName, cls.superType, cls._IsSingleton)
		else
			local from, to, name = string.find(k, "^%[(.+)%]")
			if from == nil then
				error ("Invalid module " .. k)
			end
			--如果该模块此次也被更新加载，则用新内容
			--否则构建一个，拥有name的class，不做任何覆盖
			--如果都不存在则报错
			dummyModule = sandbox.module(name)
			if dummyModule ~= nil then
				component = dummyModule.module
			else
				realClass = debug.getregistry()._LOADED[name]
				assert(realClass, "class" .. k .. "can not found")
				cls = classWrapper.Class(realClass.typeName, realClass.superType, realClass._IsSingleton)
			end
		end
	end

	return cls 
end
function classWrapper.GenerateComponent(component)
	if getmetatable(component) ~= nil then
		local k = dummy_module_cache[component]
		local from, to, name = string.find(k, "^%[(.+)%]")
		if from == nil then
			error ("Invalid module " .. k)
		end
		--如果该模块此次也被更新加载，则用新内容
		--否则构建一个，拥有name的component，不做任何覆盖
		--如果都不存在则报错
		dummyModule = sandbox.module(name)
		if dummyModule ~= nil then
			component = dummyModule.module
		else
			realComponent = debug.getregistry()._LOADED[name]
			assert(realComponent, "component " .. k .. "can not found")
			component = classWrapper.Component(realComponent.typeName)
		end
	end

	return component
end

function classWrapper.AddComponent(cls, component)
	component = classWrapper.GenerateComponent(component)
	local cls = classWrapper.class[cls]
	if cls == nil then
		error (" AddComponent but can not find class " .. name)
		return
	end
	table.insert(cls.components, component)
end

function classWrapper.AddComponents(cls, components)
	for i = 1, #components do
		local component = components[i]
		classWrapper.AddComponent(cls, component)
	end
end

local _wrapperModule = { 

}

local wrapper_dummy_mt = {
	__metatable = "WRAPPER",
	__newindex = error,
	__pairs = error,
	__tostring = function(self) return _wrapperModule[self] end,
}

_wrapperModule["[Core.Framework.Class]"] = classWrapper
_wrapperModule[classWrapper] = "[Core.Framework.Class]"
setmetatable(classWrapper, wrapper_dummy_mt)
-- wrapperEnd

local function findloader(name)
	if reload.postfix and not _wrapperModule[name] then
		local s = string.sub(name, 1, string.len("Core.Framework"))
		if s ~= "Core.Framework" then
			name = name .. reload.postfix
		end
	end

	local msg = {}
	for _, loader in ipairs(package.searchers) do
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

local global_mt = {
	__newindex = error,
	__pairs = error,
	__metatable = "SANDBOX",
}
local _LOADED_DUMMY = {}
local _LOADED = {}
local weak = { __mode = "kv" }

local module_dummy_mt = {
	__metatable = "MODULE",
	__newindex = error,
	__pairs = error,
	__tostring = function(self) return dummy_module_cache[self] end,
}

local function make_dummy_module(name)
	local name = "[" .. name .. "]"
	if dummy_module_cache[name] then
		return dummy_module_cache[name]
	else
		if _wrapperModule[name] then
			return _wrapperModule[name]
		else
			local obj = {}
			dummy_module_cache[name] = obj
			dummy_module_cache[obj] = name
			return setmetatable(obj, module_dummy_mt)
		end
	end
end

function module_dummy_mt:__index(k)
	assert(type(k) == "string", "module field is not string")
	local parent_key = dummy_module_cache[self]
	local key = parent_key .. "." .. k
	if dummy_module_cache[key] then
		return dummy_module_cache[key]
	else
		local obj = {}
		dummy_module_cache[key] = obj
		dummy_module_cache[obj] = key
		return setmetatable(obj, module_dummy_mt)
	end
end

local function make_sandbox()
	return setmetatable({}, global_mt)
end


function sandbox.require(name)
	assert(type(name) == "string")
	if _LOADED_DUMMY[name] then
		return _LOADED_DUMMY[name]
	end

	local loader, arg = findloader(name)
	local env, uv = debug.getupvalue(loader, 1)
	if env == "_ENV" then
		debug.setupvalue(loader, 1, make_sandbox())
	end
	local ret = loader(name, arg) or true
	_LOADED[name] = { module = ret }
	if env == "_ENV" then
		debug.setupvalue(loader, 1, nil)
		_LOADED[name].loader = loader
	end
	_LOADED_DUMMY[name] = make_dummy_module(name)

	return _LOADED_DUMMY[name]
end

local global_dummy_mt = {
	__metatable = "GLOBAL",
	__tostring = function(self)	return dummy_cache[self] end,
	__newindex = error,
	__pairs = error,
}

local function make_dummy(k)
	if dummy_cache[k] then
		return dummy_cache[k]
	else
		local obj = {}
		dummy_cache[obj] = k
		dummy_cache[k] = obj
		return setmetatable(obj, global_dummy_mt)
	end
end

function global_dummy_mt:__index(k)
	local parent_key = dummy_cache[self]
	assert(type(k) == "string", "Global name must be a string")
	local key = parent_key .. "." .. k
	return make_dummy(key)
end

local _inext = ipairs {}

-- the base lib function never return objects out of sandbox
local safe_function = {
	require = sandbox.require,	-- sandbox require
	pairs = pairs,	-- allow pairs during require
	next = next,
	ipairs = ipairs,
	_inext = _inext,
	print = print,	-- for debug
}

function global_mt:__index(k)
	assert(type(k) == "string", "Global name must be a string")
	if safe_function[k] then
		return safe_function[k]
	else
		return make_dummy(k)
	end
end

local function get_G(obj)
	local k = dummy_cache[obj]
	local G = _G
	for w in string.gmatch(k, "[_%a]%w*") do
		if G == nil then
			error("Invalid global", k)
		end
		G=G[w]
	end
	return G
end

local function get_M(obj)
	local k = dummy_module_cache[obj]
	local M = debug.getregistry()._LOADED
	local from, to, name = string.find(k, "^%[(.+)%]")
	if from == nil then
		error ("Invalid module " .. k)
	end

	local mod = assert(M[name], "module " .. k .. "not found")
	return mod
end

local function get_W(obj)
	local k = _wrapperModule[obj]
	local M = debug.getregistry()._LOADED
	local from, to, name = string.find(k, "^%[(.+)%]")
	if from == nil then
		error ("Invalid module " .. k)
	end
	local mod = assert(M[name])
	return mod
end

function sandbox.value(obj)
	local meta = getmetatable(obj)
	if meta == "GLOBAL" then
		return get_G(obj)
	elseif meta == "MODULE" then
		return get_M(obj)
	elseif meta == "WRAPPER" then
		return get_W(obj)
	else
		error("Invalid object" .. obj)
	end
end

function sandbox.init(list)
	dummy_cache = setmetatable({}, weak)
	dummy_module_cache = setmetatable({}, weak)

	for k,v in pairs(_LOADED_DUMMY) do
		_LOADED_DUMMY[k] = nil
	end
	for k,v in pairs(_LOADED) do
		_LOADED[k] = nil
	end

	if list then
		for _,name in ipairs(list) do
			print("==yc== init dummy ", name)
			_LOADED_DUMMY[name] = make_dummy_module(name)
		end
	end

end

function sandbox.isdummy(v)
	if safe_function[v] then
		return true
	end
	return getmetatable(v) ~= nil
end

function sandbox.module(name)
	return _LOADED[name]
end

function sandbox.clear()
	dummy_cache = nil
	dummy_module_cache = nil
	for k, v in pairs(_LOADED) do
		_LOADED[k] = nil
	end
end

end	-- sandbox end

function reload.list()
	local list = {}
	for k in pairs(debug.getregistry()._LOADED) do
		table.insert(list, k)
	end
	return list
end

local accept_key_type = {
	number = true,
	string = true,
	boolean = true,
}

local function enum_object(value)
	local print = reload.print
	local all = {}
	local path = {}
	local objs = {}
	local classes = {}

	local function iterate(value, inClass)
		if inClass == nil then
			inClass = false
		end

		if sandbox.isdummy(value) then
			if print then print("ENUMDUMMY", value, table.concat(path, ".")) end
			table.insert(all, { value, table.unpack(path) })
			return
		end
		local t = type(value)
		if t == "function" or t == "table" then
			if print then print("ENUM", value, table.concat(path, ".")) end
			table.insert(all, { value, table.unpack(path) })

			if t == "table" then
				if value.__IsClass then
					if print then print ("ENUMFINDCLASS", value, table.concat(path, ".")) end
					classes[value] = true
					inClass = true
				end
			end

			if objs[value] then
				-- already unfold
				return
			end
			objs[value] = true
		else
			return
		end
		local depth = #path + 1
		if t == "function" then
			local i = 1
			while true do
				local name, v = debug.getupvalue(value, i)
				print("==yc== getupvalue ", value , " name is ", name, v)
				if name == nil or name == "" then
					break
				else
					if not name:find("^[_%w]") then
						error("Invalid upvalue : " .. table.concat(path, "."))
					end
					local vt = type(v)
					if vt == "function" or vt == "table" then
						path[depth] = name
						path[depth + 1] = i
						iterate(v, inClass)
						path[depth] = nil
						path[depth + 1] = nil
					end
				end
				i = i + 1
			end
		else	-- table
			for k,v in pairs(value) do
				if not accept_key_type[type(k)] then
					error("Invalid key : " .. k .. " " .. table.concat(path, "."))
				end
				if inClass and sandbox.isDefaultMethods(k) then
					k = "_" .. k
				end

				path[depth] = k
				iterate(v, inClass)
				path[depth] = nil
			end
		end
	end
	iterate(value)
	return all, classes 
end

local function find_object(mod, name, id , ...)
	if mod == nil or name == nil then
		return mod
	end
	local t = type(mod)
	if t == "table" then
		return find_object(mod[name] , id , ...)
	else
		assert(t == "function")
		local i = 1
		while true do
			local n, value = debug.getupvalue(mod, i)
			if n == nil or name == "" then
				return
			end
			if n == name then
				return find_object(value, ...)
			end
			i = i + 1
		end
	end
end

-- class规约
local function sameClass(old, new)
	local error = "[Class " .. new.typeName .. " ] "
	if old == nil then
		error = error .. "can not find old class " .. new.typeName
		return false, error
	end

	if not old.__IsClass then
		error = error .. "old is not a class " .. new.typeName
		return false, error
	end

	if old.typeName ~= new.typeName then
		error = error .. "old name is " .. old.typeName .. " new name is " .. new.typeName
		return false, error
	end

	local oldHasSuper = (old.superType ~= nil)
	local newHasSuper = (new.superType ~= nil)
	if oldHasSuper ~= newHasSuper then
		error = error .. "old has super " .. tostring(oldHasSuper) .. " new has super " .. tostring(newHasSuper)
		return false, error
	end
	if oldHasSuper then
		if old.superType.typeName ~= new.superType.typeName then
			print(old.superType.typeName)
			print(new.superType.typeName)
			error = error .. "old super type is " .. old.superType.typeName .. " new super type is " .. new.superType.typeName
			return false, error
		end
	end
	if old._IsSingleton ~= new._IsSingleton then
		error = error .. "old class singletons are " .. tostring(old._IsSingleton)
			.. " new class singletons are " .. tostring(new._IsSingleton)
		return false, error
	end

	-- component check
	local oldComponents = old.components
	local newComponents = new.components
	if #oldComponents ~= #newComponents then
		error = error .. " old class components num " .. #oldComponents .. " new class components num " .. #newComponents 
		return false, error
	end

	for i, newComponent in ipairs(newComponents) do
		local oldComponent = oldComponents[i]
		if newComponent.typeName ~= oldComponent.typeName then
			error = error .. " old class component index " .. i .. " is " .. oldComponent.typeName
				.. " new class component index " .. i .. " is " .. newComponent.typeName
			return false, error
		end
	end
	return true
end

local function match_objects(objects, old_module, map, globals, classes, excludeUpvalues)
	local print = reload.print
	local objPath = {}

	for _, item in ipairs(objects) do
		local obj = item[1]
		if sandbox.isdummy(obj) then
			table.insert(globals, item)
		else

			-- 根据object 寻找旧模块中的obj
			-- 如果name or id 不存在，name就是寻找module本身
			local ok, old_one = pcall(find_object,old_module, table.unpack(item, 2))

			-- 只有在class作为module的时候，才去check，作为upvalue时check的oldone是upvalue而不是module
			local checkClass = false
			if table.unpack(item, 2) == nil then
				checkClass = true
			end

			print("==yc== find object ", table.unpack(item, 2), obj, old_one)
			if not ok then
				local current = { table.unpack(item, 2) }
				error ( "type mismatch : " .. table.concat(current, ",") )
			end

			if old_one == nil then
				map[obj] = map[obj] or false
			elseif type(old_one) ~= type(obj) then
				local current = { table.unpack(item, 2) }
				error ( "Not a table : " .. table.concat(current, ",") )
			end

			-- 这里的改动是允许upvalue中包含module本身,原来没有判断old_one 是否为nil
			if map[obj] and old_one and map[obj] ~= old_one then
				local current = { table.unpack(item, 2) }
				error ( "Ambiguity table : " .. table.concat(current, ",") )
			end

			if classes[obj] and checkClass then
				local ret, msg = sameClass(old_one, obj)
				if not ret then
					local current = { table.unpack(item, 2) }
					error ( "Ambiguity Class : " .. table.concat(current, ",") .. " Error " .. msg)
				end

			end

			--[[
				old: foo1()

				new: foo4()

				override: foo1()
						  foo4()

				如果不判断old是否为nil，覆盖后不会处理foo4中的upvalue
			]]
			if old_one ~= nil then
				map[obj] = old_one
			else
				map[obj] = map[obj] or false
			end

			--[[

			exluceupvalues 是之前用于处理ctor env不一致的方法，现在已经改变
			local path = table.unpack(item, 2)
			if sandbox.isDefaultMethods(path) then
				excludeUpvalues[obj] = true
			end

			]]
		end
	end
end

local function find_upvalue(func, name)
	if not func then
		return
	end
	local i = 1
	while true do
		local n,v = debug.getupvalue(func, i)
		if n == nil or name == "" then
			return
		end
		if n == name then
			return i
		end
		i = i + 1
	end
end

local function match_upvalues(map, upvalues, excludeUpvalues)
	upvalues["exclude"] = {}

	for new_one , old_one in pairs(map) do
		if type(new_one) == "function" then
			if excludeUpvalues[new_one] ~= nil then
				upvalues["exclude"][new_one] = {}
			end

			local i = 1
			while true do
				local name, value = debug.getupvalue(new_one, i)
				if name == nil or name == "" then
					break
				end

				print("==yc== match_upvalues ", name, value)
				local old_index = find_upvalue(old_one, name)
				local id = debug.upvalueid(new_one, i)

				if excludeUpvalues[new_one] ~= nil and old_index then
					upvalues["exclude"][new_one][id] = {
						func = old_one,
						index = old_index,
					}
				else
					if not upvalues[id] and old_index then
						upvalues[id] = {
							func = old_one,
							index = old_index,
							oldid = debug.upvalueid(old_one, old_index),
						}
					elseif old_index then
						local oldid = debug.upvalueid(old_one, old_index)
						if oldid ~= upvalues[id].oldid then
							error (string.format("Ambiguity upvalue : %s .%s",tostring(new_one),name))
						end
					end
				end
				i = i + 1
			end
		end
	end
end

local function reload_list(list)
	local _LOADED = debug.getregistry()._LOADED
	local all = {}
	--两遍遍历，第一遍把所有模块加载进来,需要对component进行预处理
	for _, mod in ipairs(list) do
		sandbox.require(mod)
	end

	--第二遍处理
	for _, mod in ipairs(list) do
		print("==yc== reload begin", mod)

		print("==yc== require begin ", mod)
		sandbox.require(mod)
		print("==yc== require end", mod)
		local m = sandbox.module(mod)

		print("==yc== enum object begin ", mod)
		local objs, classes= enum_object(m.module)
		print("==yc== enum object end ", mod)

		local old_module = _LOADED[mod]
		local result = {
			globals = {},
			map = {},
			upvalues = {},
			excludeUpvalues = {},  -- 记录了哪些函数的env可以和推导出来的不一致，直接使用旧的
			old_module = old_module,
			module = m ,
			objects = objs,
			classes = classes,
		}
		all[mod] = result
		
		print("==yc== match object begin ", mod)
		match_objects(objs, old_module, result.map, result.globals, 
		result.classes, result.excludeUpvalues) -- find match table/func between old module and new one
		print("==yc== match object end ", mod)

		print("==yc== match upvalue begin ", mod)
		match_upvalues(result.map, result.upvalues, result.excludeUpvalues) -- find match table/func between old module and new's upvalues
		print("==yc== match upvalue end ", mod)

		print("==yc== reload end", mod)
	end
	return all
end

local function set_object(v, mod, name, tmore, fmore, ...)
	if mod == nil then
		return false
	end
	if type(mod) == "table" then
		if not tmore then	-- no more
			mod[name] = v
			return true
		end
		return set_object(v, mod[name], tmore, fmore, ...)
	else
		local i = 1
		while true do
			local n, value = debug.getupvalue(mod, i)
			if n == nil or name == "" then
				return false
			end
			if n == name then
				if not fmore then
					debug.setupvalue(mod, i, v)
					return true
				end
				return set_object(v, value, fmore, ...)	-- skip tmore (id)
			end
			i = i + 1
		end
	end
end

local function patch_funcs(upvalues, map)
	for value in pairs(map) do
		if type(value) == "function" then
			local i = 1
			while true do
				local name,v = debug.getupvalue(value, i)
				if name == nil or name == "" then
					break
				end

				local id = debug.upvalueid(value, i)
				local uv = nil
				if upvalues["exclude"][value] ~= nil then
					uv = upvalues["exclude"][value][id]
				else
					uv = upvalues[id]
				end

				if uv then
					if print then print("JOIN", value, name) end
					debug.upvaluejoin(value, i, uv.func, uv.index)
				end
				i = i + 1
			end
		end
	end
end

local function merge_objects(all)

	local REG = debug.getregistry()
	local _LOADED = REG._LOADED
	local print = reload.print

	local test_one = nil
	for mod_name, data in pairs(all) do
		print("==yc== merge object begin ", mod_name)
		local map = data.map
		if data.old_module then
			patch_funcs(data.upvalues, map)
			for new_one, old_one in pairs(map) do
				if type(new_one) == "table" and old_one then
					-- merge new_one into old_one
					if print then print("COPY", old_one) end
					for k,v in pairs(new_one) do
						if type(v) ~= "table" or	-- copy values not a table
							getmetatable(v) ~= nil or -- copy dummy
							old_one[k] == nil then	-- copy new object
							print ("COPY k, v ", k, v, old_one)
							old_one[k] = v
						end
					end
				end
			end
			for _, item in ipairs(data.objects) do
				local v = item[1]
				if not sandbox.isdummy(v) then
					if not map[v] then
						-- insert new object
						local ok = set_object(v, data.old_module, table.unpack(item,2))
						if print then print("MOVE", mod_name, table.concat(item,".",2),ok) end
					end
				end
			end
		else
			_LOADED[mod_name] = data.module.module
		end
		
		print("==yc== merge object end", mod_name)
	end
end

local function solve_globals(all)
	-- solve_globals 并不只是字面意思，主要是为了解决所有dummy处的引用
	local _LOADED = debug.getregistry()._LOADED
	local print = reload.print
	local i = 0
	for mod_name, data in pairs(all) do
		for gk, item in pairs(data.globals) do
			-- solve one global
			local v = item[1]
			local path = tostring(v)
			local value
			local unsolved
			local invalid
			if getmetatable(v) == "GLOBAL" then
				local G = _G
				for w in string.gmatch(path, "[_%a]%w*") do
					if G == nil then
						invalid = true
						break
					end
					G=G[w]
				end
				value = G
			elseif getmetatable(v) == "MODULE" then
				value = sandbox.value(v)
			elseif getmetatable(v) == "WRAPPER" then
				value = sandbox.value(v)
			else
				invalid = true
				unsolved = true
			end

			if invalid then
				if print then print("GLOBAL INVALID", path) end
				data.globals[gk] = nil
			elseif not unsolved then
				i = i + 1
				if print then print("GLOBAL", path, value, mod_name, table.unpack(item, 2)) end
				set_object(value, _LOADED[mod_name], table.unpack(item,2))
				data.globals[gk] = nil
			end
		end
	end
	return i
end

local function update_funcs(map)
	local root = debug.getregistry()
	local co = coroutine.running()
	local exclude = { [map] = true , [co] = true }
	local getmetatable = debug.getmetatable
	local getinfo = debug.getinfo
	local getlocal = debug.getlocal
	local setlocal = debug.setlocal
	local getupvalue = debug.getupvalue
	local setupvalue = debug.setupvalue
	local getuservalue = debug.getuservalue
	local setuservalue = debug.setuservalue
	local type = type
	local next = next
	local rawset = rawset

	exclude[exclude] = true


	local update_funcs_

	local function update_funcs_frame(co,level)
		local info = getinfo(co, level+1, "f")
		if info == nil then
			return
		end
		local f = info.func
		info = nil
		update_funcs_(f)
		local i = 1
		while true do
			local name, v = getlocal(co, level+1, i)
			if name == nil then
				if i > 0 then
					i = -1
				else
					break
				end
			end
			local nv = map[v]
			if nv then
				setlocal(co, level+1, i, nv)
				update_funcs_(nv)
			else
				update_funcs_(v)
			end
			if i > 0 then
				i = i + 1
			else
				i = i - 1
			end
		end
		return update_funcs_frame(co, level+1)
	end

	function update_funcs_(root)	-- local function
		if exclude[root] then
			return
		end
		local t = type(root)
		if t == "table" then
			exclude[root] = true
			local mt = getmetatable(root)
			if mt then update_funcs_(mt) end
			local tmp
			for k,v in next, root do
				local nv = map[v]
				if nv then
					rawset(root,k,nv)
					update_funcs_(nv)
				else
					update_funcs_(v)
				end
				local nk = map[k]
				if nk then
					if tmp == nil then
						tmp = {}
					end
					tmp[k] = nk
				else
					update_funcs_(k)
				end
			end
			if tmp then
				for k,v in next, tmp do
					root[k], root[v] = nil, root[k]
					update_funcs_(v)
				end
				tmp = nil
			end
		elseif t == "userdata" then
			exclude[root] = true
			local mt = getmetatable(root)
			if mt then update_funcs_(mt) end
			local uv = getuservalue(root)
			if uv then
				local tmp = map[uv]
				if tmp then
					setuservalue(root, tmp)
					update_funcs_(tmp)
				else
					update_funcs_(uv)
				end
			end
		elseif t == "thread" then
			exclude[root] = true
			update_funcs_frame(root,2)
		elseif t == "function" then
			exclude[root] = true
			local i = 1
			while true do
				local name, v = getupvalue(root, i)
				if name == nil then
					break
				else
					local nv = map[v]
					if nv then
						setupvalue(root, i, nv)
						update_funcs_(nv)
					else
						update_funcs_(v)
					end
				end
				i=i+1
			end
		end
	end

	-- nil, number, boolean, string, thread, function, lightuserdata may have metatable
	for _,v in pairs { nil, 0, true, "", co, update_funcs, debug.upvalueid(update_funcs,1) } do
		local mt = getmetatable(v)
		if mt then update_funcs_(mt) end
	end

	update_funcs_frame(co, 2)
	update_funcs_(root)
end

function reload.reload(list)
	print("==yc== reload all start")
	local old_print = print
	local print = reload.print
	local REG = debug.getregistry()
	local _LOADED = REG._LOADED
	local need_reload = {}
	for _,mod in ipairs(list) do
		need_reload[mod] = true
	end
	local tmp = {}
	for k in pairs(_LOADED) do
		if not need_reload[k] then
			table.insert(tmp, k)
		end
	end
	sandbox.init(tmp)	-- init dummy modoule existed

	local ok, result = xpcall(reload_list, debug.traceback, list)
	if not ok then
		sandbox.clear()
		if print then print("ERROR", result) end
		return ok, result
	end

	merge_objects(result)

	for _, data in pairs(result) do
		if data.module.loader then
			debug.setupvalue(data.module.loader, 1, _ENV)
		end
	end

	repeat
		local n = solve_globals(result)
	until n == 0

	local func_map = {}
	for _, data in pairs(result) do
		for k,v in pairs(data.map) do
			-- 这里必须判断 v也是function，否则新添加的function = false，会导致替换所有false
			if type(k) == "function" and type(v) == "function" then
				print("UPDATEFUNC ", k, v)
				func_map[v] = k
			end
		end
	end
	result = nil
	sandbox.clear()

	update_funcs(func_map)

	old_print("==yc== reload all end")
	return true
end

return reload
