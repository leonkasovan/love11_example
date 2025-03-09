local max_player = 2
local players = {}
local spriteBatch
local atlas_dat = {}
local frame_no = 0
local atlas_img_w, atlas_img_h
local tick = 0
local action_id = 0

zangief_actions = {
	[1] = function() return 0 end,
	[2] = function() return 1234 end,
	[3] = function() return 688 end,
	[4] = function() return 788 end,
	[5] = function() return 888 end,
	[6] = function() return 95 end,
	[7] = function() return 10 end,
	[8] = function() return 196 end,
	[9] = function() return 199 end,
	[10] = function() return 198 end,
	[11] = function() return 42 end,
	[12] = function() return 41 end,
	[13] = function() return 96 end,
	[14] = function() return 20 end,
	[15] = function() return 21 end
}

ken_actions = {
	[1] = function() return 0 end,
	[2] = function() return 5 end,
	[3] = function() return 20 end,
	[4] = function() return 21 end,
	[5] = function() return 22 end,
	[6] = function() return 40 end,
	[7] = function() return 45 end,
	[8] = function() return 46 end,
	[9] = function() return 56 end,
	[10] = function() return 106 end,
	[11] = function() return 160 end,
	[12] = function() return 181 end,
	[13] = function() return 192 end,
	[14] = function() return 195 end,
	[15] = function() return 210 end
}

ryu_actions = {
	[1] = function() return 0 end,
	[2] = function() return 5 end,
	[3] = function() return 20 end,
	[4] = function() return 21 end,
	[5] = function() return 22 end,
	[6] = function() return 40 end,
	[7] = function() return 45 end,
	[8] = function() return 46 end,
	[9] = function() return 56 end,
	[10] = function() return 106 end,
	[11] = function() return 160 end,
	[12] = function() return 181 end,
	[13] = function() return 192 end,
	[14] = function() return 195 end,
	[15] = function() return 210 end
}

wolverine_actions = {
	[1] = function() return 0 end,
	[2] = function() return 5 end,
	[3] = function() return 20 end,
	[4] = function() return 21 end,
	[5] = function() return 425 end,
	[6] = function() return 41 end,
	[7] = function() return 245 end,
	[8] = function() return 410 end,
	[9] = function() return 215 end,
	[10] = function() return 106 end,
	[11] = function() return 3500 end,
	[12] = function() return 181 end,
	[13] = function() return 192 end,
	[14] = function() return 195 end,
	[15] = function() return 210 end
}

function trim(s)
	return s:match("^%s*(.-)%s*$")
end

function split(inputstr)
	local t = {}
	for str in string.gmatch(inputstr, "([^,]+)") do
		table.insert(t, trim(str))
	end
	return t
end

function loadChar(name, x, y)
	player = {}
	player.name = name
	player.atlas_img = love.graphics.newImage(player.name .. ".png")
	player.atlas_dat = {}
	for line in io.lines(player.name .. ".tsv") do -- Iterate through each line of player.tsv (tab separated values)
		if #line > 0 then
			src_x, src_y, src_w, src_h, dst_x, dst_y, dst_w, dst_h, spr_group_id, spr_img_no = line:match(
				"(%d+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)%D(%d+)")
			src_x = tonumber(src_x)
			src_y = tonumber(src_y)
			src_w = tonumber(src_w)
			src_h = tonumber(src_h)
			dst_x = tonumber(dst_x)
			dst_y = tonumber(dst_y)
			dst_w = tonumber(dst_w)
			dst_h = tonumber(dst_h)
			spr_group_id = tonumber(spr_group_id)
			spr_img_no = tonumber(spr_img_no)

			-- Ensure atlas_dat[group_id] is a table before assigning values
			if player.atlas_dat[spr_group_id] == nil then
				player.atlas_dat[spr_group_id] = {} -- Create a new table for this key
			end
			player.atlas_dat[spr_group_id][spr_img_no] = { src_x, src_y, src_w, src_h, dst_x, dst_y, dst_w, dst_h }
		end
	end
	player.atlas_img_w, player.atlas_img_h = player.atlas_img:getDimensions()
	player.sprites = love.graphics.newSpriteBatch(player.atlas_img)
	player.state = 0
	player.x = x
	player.y = y
	player.tick = 0
	player.frame_no = 1

	local action_id = nil
	local new_action_id = nil
	player.anims = {}
	for line in io.lines(player.name .. ".air") do
		line = trim(line)
		if #line == 0 then goto skip end           -- check if empty line
		if string.byte(line, 1) == 59 then goto skip end -- check if commented using ';' = byte 59

		-- parse [Begin Action ID]
		new_action_id = line:match("^%[[Bb][Ee][Gg][Ii][Nn]%s+[Aa][Cc][Tt][Ii][Oo][Nn]%s+(%d+)%]$")

		if new_action_id ~= nil then
			action_id = tonumber(new_action_id)
			goto skip
		end

		-- parse animation element: spr_group_id, spr_img_no, spr_x, spr_y, ticks, flips, color blending
		spr_group_id, spr_img_no, spr_x, spr_y, last_data = line:match(
			"(%d+)%s*,%s*(%d+)%s*,%s*([%d%-]+)%s*,%s*([%d%-]+)%s*,%s*(.-)$")
		if action_id ~= nil and spr_group_id ~= nil and last_data ~= nil then
			spr_group_id = tonumber(spr_group_id)
			spr_img_no = tonumber(spr_img_no)
			spr_x = tonumber(spr_x)
			spr_y = tonumber(spr_y)
			if player.anims[action_id] == nil then
				player.anims[action_id] = {}
			end
			anim = {}
			anim.spr_group_id = spr_group_id
			anim.spr_img_no = spr_img_no
			anim.spr_x = spr_x
			anim.spr_y = spr_y
			anim.ticks = tonumber(last_data)
			if anim.ticks == nil then
				data = split(last_data)
				anim.ticks = tonumber(data[1])
				if anim.ticks == nil then
					print("invalid", line)
				else
					if anim.ticks < 0 then
						anim.ticks = 20
					end
				end
			end
			anim.flip = nil
			anim.blending = nil
			table.insert(player.anims[action_id], anim)
			goto skip
		end

		::skip::
	end

	return player
end

function love.load()
	love.window.setVSync(1)

	table.insert(players, loadChar("Zangief", 0, 20))
	table.insert(players, loadChar("Zangief", 200, 20))
	table.insert(players, loadChar("Zangief", 400, 20))
	table.insert(players, loadChar("Zangief", 600, 20))

	table.insert(players, loadChar("Zangief", 0, 200))
	table.insert(players, loadChar("Zangief", 200, 200))
	table.insert(players, loadChar("Zangief", 400, 200))
	table.insert(players, loadChar("Zangief", 600, 200))

	table.insert(players, loadChar("Zangief", 0, 400))
	table.insert(players, loadChar("Zangief", 200, 400))
	table.insert(players, loadChar("Zangief", 400, 400))
	table.insert(players, loadChar("Zangief", 600, 400))
end

function love.update(dt)
	local dt, anim

	for k, player in pairs(players) do
		player.sprites:clear()
		player.tick = player.tick + 1
		if player.anims[player.state] == nil then
			print("error: player.anims[player.state] is nil", player.state)
		else
			if player.anims[player.state][player.frame_no] == nil then
				print("error: layer.anims[player.state][player.frame_no] is nil", player.state, player.frame_no)
			else
				anim = player.anims[player.state][player.frame_no]
				if anim ~= nil then
					if player.tick > anim.ticks then
						player.frame_no = player.frame_no + 1
						if player.anims[player.state] ~= nil and player.frame_no > #player.anims[player.state] then
							player.state = zangief_actions[math.random(1, 15)]()
							player.frame_no = 1
						end
						player.tick = 0
					end
					dt = nil
					if player.state == nil or player.frame_no == nil then
						print("error: player.state or player.frame_no is nil", player.state, player.frame_no)
					else
						dt = player.atlas_dat[anim.spr_group_id][anim.spr_img_no]
					end

					if dt ~= nil then
						player.sprites:add(
							love.graphics.newQuad(dt[1], dt[2], dt[3], dt[4], player.atlas_img_w, player.atlas_img_h),
							player.x + dt[5] + anim.spr_x, player.y + dt[6] + anim.spr_y)
					else
						print(string.format("atlas_dat is nil, group=%d img_no=%d", anim.spr_group_id, anim.spr_img_no))
					end
				else
					print(string.format("anim is nil, state=%d frame=%d", player.state, player.frame_no))
				end
			end
		end
	end
end

function love.draw()
	-- Finally, draw the sprite batch to the screen.
	for k, player in pairs(players) do
		love.graphics.draw(player.sprites)
		love.graphics.print("Action: " .. tostring(player.state), player.x, player.y + 150)
	end
	love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS()), 700, 0)
end
