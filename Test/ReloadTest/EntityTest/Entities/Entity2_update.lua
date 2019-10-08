local try = require("Core.Framework.Exception")
local Monster = {}

function Monster:do1() 
    try(function()
        print("monster do1 new")
    end).
    catch(function(ex)
    end)
end

return Monster