
local AccessControl = {}

function AccessControl.readOnly(tab)
    local mt = {
    __index = tab,
    __newindex = function(t, k , v)
        error("Try to modify a read-only table")
                end
    }
    setmetatable(tab, mt)
    return tab
end

return AccessControl
