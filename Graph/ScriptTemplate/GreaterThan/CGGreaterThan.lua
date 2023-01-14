local CGGreaterThan = CGGreaterThan or {}
CGGreaterThan.__index = CGGreaterThan

function CGGreaterThan.new()
    local self = setmetatable({}, CGGreaterThan)
    self.inputs = {}
    return self
end

function CGGreaterThan:setInput(index, func)
    self.inputs[index] = func
end

function CGGreaterThan:getOutput(index)
    return self.inputs[0]() > self.inputs[1]()
end

return CGGreaterThan
