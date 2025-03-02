function love.load()
  -- Load our image we want to draw many times
  image = love.graphics.newImage("dirt.png")

  -- The number of tiles we want to draw is pretty much the number
  -- that will fit on the screen
  maxX = math.ceil(love.graphics.getWidth()  / image:getWidth())  + 2
  maxY = math.ceil(love.graphics.getHeight() / image:getHeight()) + 2
  local size = maxX * maxY
  print(size)

  -- Set up a sprite batch with our single image and the max number of times we
  -- want to be able to draw it. Later we will call spriteBatch:add() to tell
  -- Love where we want to draw our image
  spriteBatch = love.graphics.newSpriteBatch(image, size)
  setupSpriteBatch()
end

function love.update(dt)
  -- If we were using a moving background, we would want to only call
  -- setupSpriteBatch when its range or position changed
  setupSpriteBatch()
end

function setupSpriteBatch()
  spriteBatch:clear()

  -- Set up (but don't draw) our images in a grid
  for y = 0, maxY do
    for x = 0, maxX do
      -- Convert our x/y grid references to x/y pixel coordinates
      local xPos = x * image:getWidth()
      local yPos = y * image:getHeight()

      -- Add the image we previously set to this point
      spriteBatch:add(xPos, yPos)
    end
  end
end

function love.draw()
  -- Draw the spriteBatch with only one call!
  love.graphics.setColor(255,255,255)
  love.graphics.draw(spriteBatch)

  -- Draw FPS in the bottom right corner
  love.graphics.setColor(255,0,0)
  love.graphics.print(tostring(love.timer.getFPS()), love.graphics.getWidth()-30, love.graphics.getHeight()-20)
end
