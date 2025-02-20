-- 所有定义过的类列表，key为类的类型名称，value为对应的虚表
local __ClassTypeList = { }

-- 类的继承关系数据，用于处理Hotfix等逻辑。
-- 数据形式：key为ClassType，value为继承自它的子类列表。
local __InheritRelationship = {}


local Class = {}

local __defaultMethods = {
    ctor = false,
    init = false,
    start = false,
    stop = false,
    destroy = false,
}

local __constructMethods = {
    ctor = true, 
    init = true, 
    start = true,
}

local reload = false

function Class.createSingletonClass(cls, ...)
    if cls._instance == nil then
        cls._instance = cls.new(...)
    end
    return cls._instance
end

function Class.setReload(flag)
    if flag == false then
        Class.OnReload()
    end
    reload = flag
end

local TypeNames = {}
-- 参数含义为：
-- typeName: 字符串形式的类型名称
-- superType: 父类的类型，可以为nil
-- isSingleton: 是否是单例模式的类
function Class.Class(typeName, superType, isSingleton)
    -- 该table为类定义对应的表
    local classType = { __IsClass = true }

    -- 类型名称
    classType.typeName = typeName
 
    if TypeNames[typeName] ~= nil then
        error("The class name is used already!!!" .. typeName)
    else
        TypeNames[typeName] = classType
    end

    classType._IsSingleton = isSingleton or false

    -- Component列表
    classType.components = {}
    classType.componentNames = {}


    -- 父类类型
    classType.superType = superType
    classType.superCachedKeys = {} -- reload之后需要清空
    -- 在Class身上记录继承关系
    -- Todo：在修改了继承关系的情况下，Reload和Hotfix可能会存在问题
    classType._inheritsCount = 0
    if superType ~= nil then
        local cache = {}
        local counter = 1
        local curClass = superType
        while curClass do
            cache[counter] = curClass
            counter = counter + 1
            curClass = curClass.superType
        end
        classType._classInherits = cache
        classType._inheritsCount = counter
    end


    -- 记录类的继承关系
    if superType then
        if __InheritRelationship[superType] == nil then
            __InheritRelationship[superType] = {}
        end
        table.insert(__InheritRelationship[superType], classType)
    else
        __InheritRelationship[classType] = {}
    end

    local function objToString(self)
        if not self.__instanceName then
            local str = tostring(self)
            local _, _, addr = string.find(str, "table%s*:%s*(0?[xX]?%x+)")
            self.__instanceName =  string.format("Class %s : %s", classType.typeName, addr)
        end

        return self.__instanceName
    end

    local function objGetClass(self)
        return classType
    end

    local function objGetType(self)
        return classType.typeName
    end

    -- 创建对象的方法。
    classType.new = function(...)
        -- 该table为对象对应的表
        local obj = { }

        -- 对象的toString方法，输出结果为类型名称 内存地址。
        obj.toString = objToString

        -- 获取类
        obj.getClass = objGetClass

        -- 获取类型名称的方法。
        obj.getType = objGetType

        -- 递归的构造过程
        local createObj = function(class, object, ...)
            if class.ctor then
                class.ctor(object, ...)
            end
        end

        -- 设置对象表的metatable为虚表的索引内容
        setmetatable(obj, { __index = __ClassTypeList[classType]})

        -- 构造对象
        createObj(classType, obj, ...)
        return obj
    end

    -- 类的toString方法。
    classType.toString = function(self)
        return self.typeName
    end

    if classType._IsSingleton then
        classType.GetInstance = function(...)
            return Class.createSingletonClass(classType, ...)
        end
    end

    classType.setSuperMeta = function()
        if superType then
            -- 有父类存在时，设置类身上的super属性
            classType.super = setmetatable( { },
            {
                __index = function(tbl, key)
                    local func = __ClassTypeList[superType][key]
                    if "function" == type(func) then
                        -- 缓存查找结果
                        -- Todo，要考虑reload的影响
                        tbl[key] = func
                        return func
                    else
                        error("Accessing super class field are not allowed!")
                    end
                end
            } )
        end
    end

    classType.setSuperMeta()

    -- 虚表对象。
    local vtbl = { }
    __ClassTypeList[classType] = vtbl


    -- default function 生成
    local __createDefaultMethodFunc = function(classType, name, overrideFunc)
        local retFunction = nil
        if __constructMethods[name] then
            retFunction = function(...)
                if overrideFunc then
                    overrideFunc(...)
                else
                    if classType.superType then
                        local superMethod = classType.superType[name]
                        if superMethod ~= nil and type(superMethod) == "function" then
                            superMethod(...)
                        end
                    end
                end

                local components = classType.components
                for i = 1, #components do 
                    local v = components[i][name]
                    if v and type(v) == "function" then
                        v(...)
                    end
                end
            end
        else
            retFunction = function(...)
                local components = classType.components
                for i = 1, #components do 
                    local v = components[i][name]
                    if v and type(v) == "function" then
                        v(...)
                    end
                end

                if overrideFunc then
                    overrideFunc(...)
                else
                    if classType.superType then
                        local superMethod = classType.superType[name]
                        if superMethod ~= nil and type(superMethod) == "function" then
                            superMethod(...)
                        end
                    end
                end
            end
        end
        
        return retFunction
    end

    -- 类的metatable设置，属性写入虚表，
    setmetatable(classType,
    {
        __index = function(tbl, key)
            return vtbl[key]
        end,

        __newindex = function(tbl, key, value)

            --Todo reload能否搞定？
            --默认方法
            if __defaultMethods[key] ~= nil then
                if rawget(vtbl, key) == nil or reload or classType.__canOverrideDefaumtMethods[key] then
                    vtbl[key] =  __createDefaultMethodFunc(classType, key, value)
                    rawset(vtbl, "_" .. key, value)
                    classType.__canOverrideDefaumtMethods[key] = false
                else
                    error("class " .. classType.typeName .. " has repeat attr " .. key)
                end
            --常规方法
            else
                if rawget(vtbl, key) == nil or reload or classType.__forceAttrRepeat[key]  then
                    vtbl[key] = value
                else
                    error("class " .. classType.typeName .. " has repeat attr " .. key)
                end
            end
        end,

        -- 让类可以通过调用的方式构造。
        __call = function(self, ...)
            -- 处理单例的模式
            if classType._IsSingleton == true then 
                return Class.createSingletonClass(classType, ...)
            else
                return classType.new(...)
            end
        end
    } )


    --默认方法call所有组件的同名方法
    classType.__canOverrideDefaumtMethods = {}
    for k, v in pairs(__defaultMethods) do
        classType[k] = nil
        rawset(vtbl, "_" .. k, function() end)
        classType.__canOverrideDefaumtMethods[k] = true
    end


    -- class的属性默认是不允许被重置的，添加一个允许被显示重置的方法
    classType.__forceAttrRepeat = {}
    classType.forceAttrRepeat = function(cls, key)
        cls.__forceAttrRepeat[key] = true 
    end
    classType.clearAttrRepeat = function(cls)
        cls.__forceAttrRepeat = {}
    end

    -- 如果有父类存在，则设置虚表的metatable，属性从父类身上取
    -- 注意，此处实现了多层父类递归调用检索的功能，因为取到的父类也是一个修改过metatable的对象。
    if superType then
        setmetatable(vtbl,
        {
            __index = function(tbl, key)
                local ret = __ClassTypeList[superType][key]
                -- Todo 缓存提高了效率，但是要考虑reload时的处理。
                classType.superCachedKeys[key] = true
                vtbl[key] = ret
                return ret
            end
        } )
    end

    return classType
end

-- 判断一个类是否是另外一个类的子类
function Class.isSubClassOf(cls, otherCls)
    return type(otherCls) == "table" and
             type(cls.superType) == "table" and
           ( cls.superType == otherCls or Class.isSubClassOf(cls.superType, otherCls) )
end

-- 判断一个对象是否是一个类的实例（包含子类）
function Class.isInstanceOf(obj, cls)
    if type(obj) ~= "table" then 
        return false
    end

    local objClass = obj:getClass()
    return objClass ~= nil and type(cls) == 'table' and (cls == objClass or Class.isSubClassOf(objClass, cls) )
end

-- 用于记录类的Component列表, Component 必须显示的声明为Component
-- 数据形式：ClassType -> ComponentClassType Table
local __ComponentRelationship = {}
local ComponentNames = {} -- name -> ComponentType

local function __defaultComponentMethod(...)
end

function Class.Component(typeName)
    local componentType = {}
    
    -- add component typeName 
    componentType.__IsComponent = true
    componentType.typeName = typeName
    if ComponentNames[typeName] ~= nil then
        error("The component name is used already!!!" .. typeName)
    else
        ComponentNames[typeName] = componentType
    end

    for k, v in pairs(__defaultMethods) do
        if not componentType[k] then
            componentType[k] = __defaultComponentMethod
        end
    end

    return componentType
end

local function _addComponentAttr(cls, component)
    for name, attr in pairs(component) do
        if name ~= "typeName"  and name ~= "__IsComponent" and __defaultMethods[name] == nil then
            if type(attr) ~= "function" then
                error(string.format("[ERROR] The component attr %s is not a function ",  name))
            end

            if cls[name] == nil or reload then
                cls[name] = attr
            else
                -- 属性名称相同不覆盖而是给出警告。
                error(string.format("[WARNING] The attribute name %s is already in the Class %s!", 
                name, cls.toString(cls)))
            end
        end
    end
end
local function _addComponent(cls, component)
    assert(component.__IsComponent, "must be a component")
    assert(component.typeName ~= nil, "component must have a name" )
    assert(ComponentNames[component.typeName] ~= nil, "component must register" )
    assert(cls.componentNames[component.typeName] == nil, "class already has same component " .. component.typeName)

    cls.componentNames[component.typeName] = true
    cls.components[#cls.components + 1] = component 
    _addComponentAttr(cls, component)
end

function Class.AddComponents(cls, components)
    for i = 1, #components do
        local component = components[i]
        _addComponent(cls, component)
    end
end

function Class.AddComponent(cls, component)
    _addComponent(cls, component)
end

function Class.OnReload()
    for name, cls in pairs(TypeNames) do
        -- clear super meta
        cls.setSuperMeta()

        -- clear cached super keys
        for k, _ in pairs(cls.superCachedKeys) do
            print("CLASSCLEAR set class ", name, " key ", k, " to nil ")
            cls[k] = nil 
        end
        cls.superCachedKeys = {}

        -- reset component methods
        for _, component in ipairs(cls.components) do
            _addComponentAttr(cls, component)
        end
    end
end

return Class