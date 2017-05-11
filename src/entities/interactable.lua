local Interactable = class('Interactable')

function Interactable:initialize(x, y, command, args)
    local args = args or {}
    self.x = x
    self.y = y
    self.command = command
    self.range = args.range or nil
    self.los = args.los or true
    self.interactive = true
end

function Interactable:withinRange(character)
    if self.range then 
        local distance = tools.distance(character, self.center)
        return distance <= self.range
    end
    return true
end

function Interactable:isLineOfSight(character)
    if self.los then
        return tools.isLineOfSight(character, self)
    else 
        return true
    end
end

function Interactable:activate()
    World.signals.emit(tostring(self.command))
end

return Interactable
