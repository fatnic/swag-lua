local CharacterParserSystem = tiny.system(class('CharacterParserSystem'))

function CharacterParserSystem:initialize()

    World.characters.player = Player:new(64, 64)
    World.ecs:addEntity(World.characters.player)

    for _, enemy in pairs(require 'enemies') do
        local e = Enemy:new(enemy.x, enemy.y)
        table.insert(World.characters.enemies, e)
        e.body:setAngle(math.rad(enemy.heading))
        World.ecs:addEntity(e)
    end

end

return CharacterParserSystem
