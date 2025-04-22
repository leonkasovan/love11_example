local entities = {}
local spriteBatch, protagonist
local kfm

local palette = {
    {100, 101, 102, 0},        -- 0
    {200,201, 202, 255},      -- 1
    {255, 255, 255, 255},      -- 2
}

local paletteShader = love.graphics.newShader([[
    extern vec4 palette[16];

    vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
        int index = int(Texel(texture, textureCoords).r * 255.0);
        return palette[index];
	}
]])

paletteShader:send("palette", unpack(palette))

function love.load()
	love.window.setVSync(1)
	
	kfm = love.graphics.newImage("sffv1.sff")
end

function love.draw()
	love.graphics.clear(0.2, 0.1, 0.5)
	love.graphics.setShader(paletteShader)
	love.graphics.draw(kfm, 100, 200)
	love.graphics.setShader()
	love.graphics.print(kfm:getFormat(), 10, 30)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
