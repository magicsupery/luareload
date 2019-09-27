local class = require("Core.Framework.Class")
local IDManager = require("Core.Common.IDManager")
local EntityManager = require("Core.Common.EntityManager")
local LoggerManager = require("Core.Log.LoggerManager")

local Entity = class.Class("Entity")
function Entity:ctor(entityid)
    if entityid == nil then
        entityid = IDManager.genID()    
    end

    self.id = entityid
    self.logger = LoggerManager.getLogger(self:getType())

    EntityManager.addEntity(entityid.bytes, self)
end

function Entity:destroy()
    self.id = nil 
    self.logger = nil

    EntityManager.removeEntity(entityid.bytes)
end

return Entity