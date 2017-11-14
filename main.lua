function love.load()
  sprites = {}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  player = {}
  player.x = 200
  player.y = 200
  player.speed = 150

  zombies = {}
end

function love.update(dt)
  movePlayer(dt)
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)
  love.graphics.draw(sprites.player, player.x, player.y, player_mouse_angle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

  for i, z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y)
  end
end

function movePlayer(dt)
  -- TODO - Normalise movement vector so diagonal movement isn't faster
  if (love.keyboard.isDown("w")) then
    player.y = player.y - (player.speed * dt)
  end
  if (love.keyboard.isDown("a")) then
    player.x = player.x - (player.speed * dt)
  end
  if (love.keyboard.isDown("s")) then
    player.y = player.y + (player.speed * dt)
  end
  if (love.keyboard.isDown("d")) then
    player.x = player.x + (player.speed * dt)
  end
end

function player_mouse_angle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function spawn_zombie()
  zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 100
  table.insert(zombies, zombie)
end

function love.keypressed(key, scancode, isrepeat)
  if (key == "space") then
    spawn_zombie()
  end
end
