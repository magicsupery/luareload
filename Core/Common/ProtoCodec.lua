local class = require("Core.Framework.Class")
local msgpack = require("cmsgpack")

local ProtoCodec = class.Class("ProtoCodec")

function ProtoCodec:ctor()
    self.codec = msgpack
end

function ProtoCodec:encode(p)
    return self.codec.pack(p)
end

function ProtoCodec:decode(p)
    return self.codec.unpack(p)
end

return ProtoCodec