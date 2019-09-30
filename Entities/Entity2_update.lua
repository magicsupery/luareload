local class = require("Core.Framework.Class")
local try = require("Core.Framework.Exception")
local Monster = {}

function Monster:do1() 
    try(function()
        print("monster do1 new")
        print ("upvalue class check ", class.isInstanceOf)
    end).
    catch(function(ex)
    end)
end

return Monster