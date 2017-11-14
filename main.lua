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
  zombie_spawn_border = 30

  bullets = {}
end

function love.update(dt)
  movePlayer(dt)
  moveZombies(dt)
  moveBullets(dt)
  check_bullet_zombie_collision()
  clearDeadEntities()
  clearOffScreenBullets()
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)

  for i, z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y, zombie_player_angle(z), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
  end

  for i, b in ipairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2)
  end

  love.graphics.print("Bullet count: " .. #bullets)

  love.graphics.draw(sprites.player, player.x, player.y, player_mouse_angle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)
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

function moveZombies(dt)
  for i,z in ipairs(zombies) do
    z.x = z.x + (math.cos(zombie_player_angle(z)) * z.speed * dt)
    z.y = z.y + (math.sin(zombie_player_angle(z)) * z.speed * dt)
    checkPlayerCollision(z)
  end
end

function moveBullets(dt)
  for i,b in ipairs(bullets) do
    b.x = b.x + (math.cos(b.direction) * b.speed * dt)
    b.y = b.y + (math.sin(b.direction) * b.speed * dt)
  end
end

function player_mouse_angle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombie_player_angle(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawn_zombie()
  zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 100
  zombie.dead = false

  local side = math.random(1, 4)

  if (side == 1) then
    zombie.x = -zombie_spawn_border
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif (side == 2) then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -zombie_spawn_border
  elseif (side == 3) then
    zombie.x = love.graphics.getWidth() + zombie_spawn_border
    zombie.y = math.random(0, love.graphics.getHeight())
  else
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + zombie_spawn_border
  end

  table.insert(zombies, zombie)
end

function spawn_bullet()
  bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = player_mouse_angle()
  bullet.dead = false;

  table.insert(bullets, bullet)
end

function check_bullet_zombie_collision()
  for i, z in ipairs(zombies) do
    for j, b in ipairs(bullets) do
      if (distance(z.x, z.y, b.x, b.y) < 20) then
        z.dead = true
        b.dead = true
      end
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if (key == "space") then
    spawn_zombie()
  end
end

function love.mousepressed(x, y, button, isTouch)
  if (button == 1) then
    spawn_bullet()
  end
end

function distance(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

function checkPlayerCollision(other)
  -- TODO remove the hard-coded value of 30, replace with player collision radius
  if (distance(player.x, player.y, other.x, other.y) < 30) then
    clearZombies()
  end
end

function clearZombies()
  for i,z in ipairs(zombies) do
    zombies[i] = nil
  end
end

function clearDeadEntities()
  for i=#zombies, 1, -1 do
    local z = zombies[i]
    if z.dead == true then
      table.remove(zombies, i)
    end
  end

  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b.dead == true then
      table.remove(bullets, i)
    end
  end
end

function clearOffScreenBullets()
  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if (isWithinViewport(b.x, b.y) == false) then
      table.remove(bullets, i)
    end
  end
end

function isWithinViewport(x, y)
  return (
    x >= 0 and
    x <= love.graphics.getWidth() and
    y >= 0 and
    y <= love.graphics.getHeight()
  )
end
