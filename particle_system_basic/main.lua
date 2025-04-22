 
local sparkImage
local sparkSystem

function love.load0()
    -- Generate a small white circle as the spark texture
    local size = 16
    local imgData = love.image.newImageData(size, size)

    imgData:mapPixel(function(x, y)
        local dx = x - size / 2
        local dy = y - size / 2
        local dist = math.sqrt(dx * dx + dy * dy)
        local radius = size / 2
        if dist < radius then
            local alpha = 1 - (dist / radius) -- fade edge
            return 1, 1, 1, alpha
        else
            return 0, 0, 0, 0
        end
    end)

    sparkImage = love.graphics.newImage(imgData)

    -- Create the particle system
    sparkSystem = love.graphics.newParticleSystem(sparkImage, 50)
    sparkSystem:setParticleLifetime(0.1, 0.3)
    sparkSystem:setEmissionRate(0)
    sparkSystem:setSizes(1, 0.2)
    sparkSystem:setSizeVariation(1)
    sparkSystem:setSpread(math.pi * 2)
    sparkSystem:setSpeed(200, 400)
    sparkSystem:setRotation(0, 2 * math.pi)
    sparkSystem:setSpinVariation(1)
    sparkSystem:setColors(
        1, 1, 0.4, 1,   -- yellow start
        1, 0, 0, 0      -- red & transparent end
    )
end

function love.load()
    -- Generate a stretched white spark (oval shape)
    local width, height = 32, 8
    local imgData = love.image.newImageData(width, height)

    imgData:mapPixel(function(x, y)
        local dx = (x - width / 2) / (width / 2)
        local dy = (y - height / 2) / (height / 2)
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 1 then
            local alpha = 1 - dist
            return 1, 1, 1, alpha
        else
            return 0, 0, 0, 0
        end
    end)

    sparkImage = love.graphics.newImage(imgData)
    sparkImage:setFilter("linear", "linear") -- smooth edges

    -- Create particle system
    sparkSystem = love.graphics.newParticleSystem(sparkImage, 50)
    sparkSystem:setParticleLifetime(0.1, 0.3)
    sparkSystem:setEmissionRate(0)
    sparkSystem:setSizes(1, 0.2)
    sparkSystem:setSizeVariation(1)
    sparkSystem:setSpread(math.pi * 2)
    sparkSystem:setSpeed(200, 400)
    sparkSystem:setRotation(0, 2 * math.pi)
    sparkSystem:setSpin(-10, 10)
    sparkSystem:setSpinVariation(1)
    sparkSystem:setColors(
        1, 1, 0.4, 1,   -- bright yellow
        1, 0, 0, 0      -- fade to red and transparent
    )
end


function love.update(dt)
    sparkSystem:update(dt)

    -- Press space to trigger spark
    if love.keyboard.isDown("space") then
        triggerHitSpark(400, 300)
    end
end

function love.draw()
    love.graphics.draw(sparkSystem)
    love.graphics.print("Press SPACE to trigger hit spark", 10, 10)
end

function triggerHitSpark(x, y)
    sparkSystem:setPosition(x, y)
    sparkSystem:emit(20)
end
