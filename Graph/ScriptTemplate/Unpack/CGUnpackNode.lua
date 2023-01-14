local CGUnpackNode = CGUnpackNode or {}
CGUnpackNode.__index = CGUnpackNode

function CGUnpackNode.new()
    local self = setmetatable({}, CGUnpackNode)
    self.inputs = {}
    self.valueType = nil
    return self
end

function CGUnpackNode:setInput(index, func)
    self.outputs = func
end

function CGUnpackNode:getOutput(index)
    local res = self.outputs()
    if self.valueType == 'Color' then
        local colorVal = {'r', 'g', 'b', 'a'}
        return res[colorVal[index + 1]]
    end
    if index == 0 then
        return res.x
    elseif index == 1 then
        return res.y
    end
    if self.valueType ~= "Rect" then
        if index == 2 then
            return res.z
        elseif index == 3 then
            return res.w
        end
    else
        if index == 2 then
            return res.width
        elseif index == 3 then
            return res.height
        end

    end
end

return CGUnpackNode
