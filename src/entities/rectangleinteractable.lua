local RectangleInteracable = class('RectangleInteracable', Interactable)

function RectangleInteracable:initialize(x, y, w, h, command, args)
    local args = args or {}
    Interactable.initialize(self, x, y, command, args)
    self.width = w
    self.height = h
    self.center = { x = x + self.width / 2, y = y + self.height / 2 }
end

function RectangleInteracable:selected()
    local x,y = World.mouse.x, World.mouse.y
    return ( x >= self.x and x <= self.x + self.width) and ( y >= self.y and y <= self.y + self.height )
end


return RectangleInteracable
