local class = require("Core.Framework.Class")
local Monster = {}

function Monster:do1() 
    print ("upvalue class check ", class.isInstanceOf)
    print("new monster do1")
end

return Monster