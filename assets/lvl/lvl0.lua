-- lvl 0
-- Это костыль для решения проблемы с почетом высоты устройств.
levels[0] = function()
		
	-- load res
	local spr_micro = love.graphics.newImage("assets/spr/spr_loading.png")
	spr_micro:setFilter('nearest', 'nearest')
	local w_offset = spr_micro:getWidth() * .5
	local h_offset = spr_micro:getHeight() * .5
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local sx = math.ceil(w / spr_micro:getWidth())

	if sx > 3 then sx = sx - 1 end

	local mw = spr_micro:getWidth() * sx
	local mh = spr_micro:getHeight() * sx

	-- debug resolution
	local i = 0
	local debug_lvl = false
	function love.update()
		i = i + 1
		if i >= 90 then debug_lvl = true end 

		if (debug_lvl == true) then
			require "resource"
			level = 1
			levels[level]()
		end
	end

	local fnt_small = love.graphics.newFont('assets/fnt/fnt_gamer.ttf', 30)
	function love.draw()
		love.graphics.setBackgroundColor(hex("68386cff"))
		love.graphics.draw(spr_micro, w/2 - mw/2, h/2 - mh/2, 0, sx, sx)
		love.graphics.setFont(fnt_small)
		love.graphics.print("Loading...", 25, h - 50)
	end

end