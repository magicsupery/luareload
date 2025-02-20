local class = require("Core.Framework.Class")
local LoggerManager = require ("Core.Log.LoggerManager")

local logger = LoggerManager.getLogger("Queue")

local Queue = class.Class("Queue")

function Queue:ctor(capacity)
    self.capacity = capacity
    self.queue = {}
    self.size_ = 0
    self.head = -1
    self.rear = -1
end

function Queue:enQueue(element)
    if self.size_ == 0 then
        self.head = 0
        self.rear = 1
        self.size_ = 1
        self.queue[self.rear] = element
    else
        local temp = (self.rear + 1) % self.capacity
        if temp == self.head then
            logger:error("Error: capacity is full.")
            return false
        else
            self.rear = temp
        end

        self.queue[self.rear] = element
        self.size_ = self.size_ + 1
    end

    return true

end

function Queue:deQueue()
    if self:isEmpty() then
        logger:error("Error: The Queue is empty.")
        return 
    end
    self.size_ = self.size_ - 1
    self.head = (self.head + 1) % self.capacity
    local value = self.queue[self.head]
    return value
end

function Queue:clear()
    self.queue = nil
    self.queue = {}
    self.size_ = 0
    self.head = -1
    self.rear = -1
end

function Queue:isEmpty()
    if self:size() == 0 then
        return true
    end
    return false
end

function Queue:size()
    return self.size_
end

function Queue:printElement()
    local h = self.head
    local r = self.rear
    local str = nil
    local first_flag = true
    while h ~= r do
        if first_flag == true then
            str = "{"..self.queue[h]
            h = (h + 1) % self.capacity
            first_flag = false
        else
            str = str..","..self.queue[h]
            h = (h + 1) % self.capacity
        end
    end
    str = str..","..self.queue[r].."}"
    logger:info(str)
end

return Queue