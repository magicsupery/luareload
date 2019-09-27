local AccessControl = require("Core.Framework.AccessControl")

local Const = {
    ACCESSOR_CLIENT = 1, 
    ACCESSOR_SERVER = 2,

    ACCESSOR_INT_TO_STRING = {
        "ClientMethod", 
        "ServerMethod"
    },

    ARG_TYPE_NUMBER = {int=1, float=2, double=3}
}

return AccessControl.readOnly(Const)