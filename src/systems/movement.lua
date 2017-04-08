local MovementSystem = tiny.processingSystem(class('MovementSystem'))

MovementSystem.filter = tiny.requireAll('velocity', 'acceleration', 'position', 'speed')

function MovementSystem:initialize(args)
    local args = args or {}
    self.friction = args.friction or 0.8
end

function MovementSystem:process(e, dt)
    local friction = e.friction or self.friction

    e.velocity.x = e.velocity.x + e.acceleration.x
    e.velocity.y = e.velocity.y + e.acceleration.y

    e.position.x = e.position.x + e.velocity.x    
    e.position.y = e.position.y + e.velocity.y    

    e.velocity.x = e.velocity.x * friction
    e.velocity.y = e.velocity.y * friction

    e.acceleration.x = 0
    e.acceleration.y = 0
end

return MovementSystem
