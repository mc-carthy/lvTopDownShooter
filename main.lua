function love.load()
  sprites = {}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)

end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)
  love.graphics.draw(sprites.zombie, 100, 100)
  love.graphics.draw(sprites.player, 300, 100)
  love.graphics.draw(sprites.bullet, 200, 100)
end
