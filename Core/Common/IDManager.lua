
local bson = require ("bson")

local ObjectID = {}

function ObjectID.new()
    local obj = {}
	obj.bytes = string.sub(bson.objectid(), 3)
    obj.str = ObjectID.bin2hex(obj.bytes)
    return obj
end

function ObjectID.bin2hex(s)
    s=string.gsub(s,"(.)",function (x) return string.format("%02x",string.byte(x)) end)
    return s
end

local h2b = {
    ["0"] = 0,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["a"] = 10,
    ["b"] = 11,
    ["c"] = 12,
    ["d"] = 13,
    ["e"] = 14,
    ["f"] = 15
}

function ObjectID.hex2bin( hexstr )
    local s = string.gsub(hexstr, "(.)(.)", function ( h, l )
         return string.char(h2b[h]*16+h2b[l])
    end)
    return s
end


local IDManager = {}

function IDManager.genID()
    return ObjectID.new()
end

function IDManager.bytesToStr(bytes)
    return  ObjectID.bin2hex(bytes)
end

function IDManager.strToBytes(str)
    return ObjectID.hex2bin(str)
end

function IDManager.bytesToID(bytes)
    local obj = {}
    obj.bytes = bytes
    obj.str = IDManager.bytesToStr(bytes)
    return obj
end

return IDManager