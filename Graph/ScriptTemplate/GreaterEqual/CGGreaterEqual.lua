local CGGreaterEqual = CGGreaterEqual or {}
CGGreaterEqual.__index = CGGreaterEqual

function CGGreaterEqual.new()
    local self = setmetatable({}, CGGreaterEqual)
    self.inputs = {}
    return self
end

function CGGreaterEqual:setInput(index, func)
    self.inputs[index] = func
end

function CGGreaterEqual:getOutput(index)
    return self.inputs[0]() >= self.inputs[1]()
end

return CGGreaterEqual
