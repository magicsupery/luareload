local class = require("Core.Framework.Class")
local Monster = {}

function Monster:do1() 
    print("monster do1 new")
    print ("upvalue class check ", class.isInstanceOf)
end

return Monster