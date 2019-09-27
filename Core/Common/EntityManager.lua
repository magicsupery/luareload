local class = require("Core.Framework.Class")

local EntityManager = class.Class("EntityManager")

EntityManager._entities = {}

function EntityManager.addEntity(entityid, entity)
    EntityManager._entities[entityid] = entity
end

function EntityManager.removeEntity(entityid)
    EntityManager._entities[entityid] = nil
end

function EntityManager.getEntity(entityid)
    return EntityManager._entities[entityid]
end

return EntityManager