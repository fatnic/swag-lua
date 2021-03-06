local assets = {}

assets.images = {}
assets.sounds = {}
assets.cursors = {}

assets.images.player              = love.graphics.newImage('assets/images/player.png')
assets.images.enemy               = love.graphics.newImage('assets/images/enemy.png')
assets.images.door_horizontal     = love.graphics.newImage('assets/images/door_horizontal.png')
assets.images.door_vertical       = love.graphics.newImage('assets/images/door_vertical.png')
assets.images.doorbutton_unlocked = love.graphics.newImage('assets/images/doorbutton_unlocked.png')

assets.sounds.pistol = ripple.newSound('assets/sounds/pistol.wav')

assets.cursors.crosshair      = love.mouse.newCursor('assets/images/crosshair16.png')
assets.cursors.crosshairred   = love.mouse.newCursor('assets/images/crosshair16_red.png')
assets.cursors.crosshairgreen = love.mouse.newCursor('assets/images/crosshair16_green.png')

return assets
