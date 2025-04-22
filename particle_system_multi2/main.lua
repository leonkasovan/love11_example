local timer = 0
local interval = 0.2 -- Faster interval
local sparks = {} -- Array to hold all hit sparks

function love.load()
    -- Generate procedural textures for sparks
    local sparkImage1 = generateSlashTexture(32, 8, {1, 1, 0.4}, {1, 0, 0})
    local sparkImage2 = generateSlashTexture(24, 6, {0.5, 1, 0.5}, {0, 0.5, 1})
    local sparkImage3 = generateSlashTexture(40, 10, {1, 0.5, 0.5}, {1, 0, 1})

    -- Create first hit spark
    local hitSpark1 = love.graphics.newParticleSystem(sparkImage1, 50)
    setupParticleSystem(hitSpark1, 200, 400, {1, 1, 0.4, 1, 1, 0, 0, 0})

    -- Create second hit spark with a different color palette
    local hitSpark2 = love.graphics.newParticleSystem(sparkImage2, 50)
    setupParticleSystem(hitSpark2, 300, 600, {0.5, 1, 0.5, 1, 0, 0.5, 1, 0})

    -- Create third hit spark with a larger slash
    local hitSpark3 = love.graphics.newParticleSystem(sparkImage3, 50)
    setupParticleSystem(hitSpark3, 400, 800, {1, 0.5, 0.5, 1, 1, 0, 1, 0})

    -- Add the sparks to the array
    table.insert(sparks, hitSpark1)
    table.insert(sparks, hitSpark2)
    table.insert(sparks, hitSpark3)
end

function love.update(dt)
    -- Update all particle systems
    for _, spark in ipairs(sparks) do
        spark:update(dt)
    end

    -- Update the timer for random triggers
    timer = timer + dt
    if timer >= interval then
        timer = 0
        -- Generate a random position
        local x, y = love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight())

        -- Randomly select a spark and trigger it
        local randomSpark = sparks[love.math.random(1, #sparks)]
        triggerHitSpark(randomSpark, x, y)
    end
end

function love.draw()
    -- Draw all particle systems
    for _, spark in ipairs(sparks) do
        love.graphics.draw(spark)
    end
end

-- Trigger the spark at a specific position
function triggerHitSpark(particleSystem, x, y)
    particleSystem:setPosition(x, y)
    particleSystem:emit(20) -- Emit particles
end

-- Function to generate a slash-shaped texture procedurally
function generateSlashTexture(width, height, color1, color2)
    local imgData = love.image.newImageData(width, height)
    imgData:mapPixel(function(x, y)
        local dx = (x - width / 2) / (width / 2)
        local dy = (y - height / 2) / (height / 2)
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 1 then
            local alpha = 1 - dist
            return lerp(color1[1], color2[1], alpha),
                   lerp(color1[2], color2[2], alpha),
                   lerp(color1[3], color2[3], alpha),
                   alpha
        else
            return 0, 0, 0, 0
        end
    end)
    local sparkImage = love.graphics.newImage(imgData)
    sparkImage:setFilter("linear", "linear")
    return sparkImage
end

-- Function to set up a particle system with common parameters
function setupParticleSystem(particleSystem, speedMin, speedMax, colors)
    particleSystem:setParticleLifetime(0.1, 0.3)
    particleSystem:setEmissionRate(0)
    particleSystem:setSizes(1, 0.2)
    particleSystem:setSizeVariation(1)
    particleSystem:setSpread(math.pi * 2)
    particleSystem:setSpeed(speedMin, speedMax)
    particleSystem:setRotation(0, 2 * math.pi)
    particleSystem:setSpin(-10, 10)
    particleSystem:setSpinVariation(1)
    particleSystem:setColors(unpack(colors))
end

-- Linear interpolation helper function
function lerp(a, b, t)
    return a + (b - a) * t
end