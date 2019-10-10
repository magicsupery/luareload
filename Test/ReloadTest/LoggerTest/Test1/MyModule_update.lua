local LoggerManager = require ("Core.Log.LoggerManager")
local logger = LoggerManager.getLogger("MyModuleUpdate")
local data = {}
function data.testLogger()
    logger:info("test new")
end

function data.testLoggerUpdate()
    logger:info("test new")
end

return data