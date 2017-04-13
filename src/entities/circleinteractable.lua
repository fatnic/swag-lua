
local CircleInteractable = class('CircleInteractable', Interactable)

function CircleInteractable:initialize(x, y, radius, command, args)
    local args = args or {}
    Interactable.initialize(self, x, y, command, args)
    self.radius = radius
    self.center = { x = x, y = y }
    self.range = args.range + self.radius or nil
end

function CircleInteractable:selected()
    local mdist = tools.distance(World.mouse, self.center)
    return mdist < self.radius
end

return CircleInteractable
