local assets = {}

assets.images = {}
assets.cursors = {}

assets.images.player = love.graphics.newImage('assets/images/player.png')
assets.images.door   = love.graphics.newImage('assets/images/door.png')
assets.images.doorbutton_unlocked = love.graphics.newImage('assets/images/doorbutton_unlocked.png')

assets.cursors.crosshair = love.mouse.newCursor('assets/images/crosshair16.png')
assets.cursors.crosshairred = love.mouse.newCursor('assets/images/crosshair16_red.png')
assets.cursors.crosshairgreen = love.mouse.newCursor('assets/images/crosshair16_green.png')

return assets
