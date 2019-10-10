local LoggerManager = require ("Core.Log.LoggerManager")
local logger = LoggerManager.getLogger("MyModule")

local data = {}
function data.testLogger()
    logger:info("test old")
end


return data
