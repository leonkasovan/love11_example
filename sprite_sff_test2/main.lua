local kfm
function love.load()
	kfm = love.graphics.newMugenSprite("sffv2_rle8.sff")
end 

function love.draw()
	-- love.graphics.drawMugenSprite(kfm, 10, 30)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end