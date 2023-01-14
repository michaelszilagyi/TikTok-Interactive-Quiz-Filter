
local CGRandom = CGRandom or {}
CGRandom.__index = CGRandom

function CGRandom.new()
    local self = setmetatable({}, CGRandom)
    self.inputs = {}
    self.outputs = {}
    self.nexts = {}
    return self
end

function CGRandom:setNext(index, func)
    self.nexts[index] = func
end

function CGRandom:setInput(index, func)
    self.inputs[index] = func
end

function CGRandom:getOutput(index)
    return self.outputs[index]
end

function CGRandom:execute(index)    
    self.outputs[1] = math.random(self.inputs[1](), self.inputs[2]())
    if self.nexts[0] ~= nil then
        self.nexts[0]()
    end
end

return CGRandom
