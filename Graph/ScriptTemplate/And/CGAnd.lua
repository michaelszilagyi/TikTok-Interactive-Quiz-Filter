local CGAnd = CGAnd or {}
CGAnd.__index = CGAnd

function CGAnd.new()
    local self = setmetatable({}, CGAnd)
    self.inputs = {}
    return self
end

function CGAnd:setInput(index, func)
    self.inputs[index] = func
end

function CGAnd:getOutput(index)
    return self.inputs[0]() and self.inputs[1]()
end

return CGAnd
