-- Константы
math.randomseed(os.time())
_D2R = math.pi / -180
_R2D = -180 / math.pi

-- Математические функции
function sign(x) return x>0 and 1 or (x==0 and 0 or -1) end
function round(x) return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5) end
function clamp(val, min, max) return math.max(min, math.min(max, val)) end
function range(val, min, max)  return (val >= min) and (val <= max) end
function lerp(v0, v1, t) return (1 - t) * v0 + t * v1 end

-- Тригонометрические функции
function lengthdir_x(length, direction) return length * math.cos(direction * _D2R) end
function lengthdir_y(length, direction) return length * math.sin(direction * _D2R) end
function point_direction(x1, y1, x2, y2) return (_R2D * (math.atan2(y1 - y2, x1 - x2))) + 180 end
function angle_difference(ang1, ang2)  return ((((ang1 - ang2) % 360) + 540) % 360) - 180 end
function distance_to_point(x1, y1, x2, y2) return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 ) end
function degtorad(degree) return degree * _D2R end
function radtodeg(degree) return degree * _R2D end

-- Полет объекта к точке
function move_towards_point(obj, to_x, to_y, spd)
    local dx = to_x - obj.x
    local dy = to_y - obj.y
    local dist = dx * dx + dy * dy;

    if (dist < spd * spd) then
        obj.x = to_x
        obj.y = to_y
    else
        dist = math.sqrt(dist)
        obj.x = obj.x + dx * spd / dist
        obj.y = obj.y + dy * spd / dist
    end
end

-- GamePlay Функции
-- Удаление объекта
function instance_destroy(_obj, i)
	table.remove(_obj, i)
	instances = instances - 1
	--table.remove(instances, i)
end

-- функция в вощращает реальное напрвление(BETA)
function real_direction(_dir)
	local temp = _dir
	return (_dir > 0) and _dir or (-360 - temp) * -1
end

--------------- Анимации
-- Цикличная
function animation_loop(_obj)
	_obj.image_index = _obj.image_index + _obj.image_speed

	if (_obj.image_index >= _obj.sprite_sheet.image_number + 1) then
		_obj.image_index = 1
	end
end

-- До последнего кадра
function animation_to_end(_obj)
	if _obj.image_index < (_obj.sprite_sheet.image_number + 1) - _obj.image_speed then
		_obj.image_index = _obj.image_index + _obj.image_speed
		_obj.animation_end = false
	else
		_obj.animation_end = true
	end
end

-- От начального до конечного и наоборот
function animation_ping_pong(_obj)
	_obj.image_index = _obj.image_index + _obj.image_speed

	-- To end
	if (_obj.image_index + _obj.image_speed <= 1) then
		_obj.image_speed = _obj.image_speed * -1
	end

	-- To start
	if _obj.image_index + _obj.image_speed >= _obj.sprite_sheet.image_number  + 1 then
		_obj.image_speed = _obj.image_speed * -1
	end
end

-- В процентный формат
function rgba(r, g, b, a)
	local r2 = r * 0.0039215686
	local g2 = g * 0.0039215686
	local b2 = b * 0.0039215686
	local a2 = a * 0.01 or 100
	return r2, g2, b2, a2
end

-- HEX в RGBA
function hex(hex_color)
	local color = string.lower(hex_color)

	local R = tonumber("0x"..string.sub(color, 0, 2)) * 0.0039215686274
	local G = tonumber("0x"..string.sub(color, 3, 4)) * 0.0039215686274
	local B = tonumber("0x"..string.sub(color, 5, 6)) * 0.0039215686274
	local A = tonumber("0x"..string.sub(color, 7, 8)) * 0.0039215686274
	
	return R, G, B, A
end

-- ООП
-- Наследование
function inherit(child, parent) setmetatable(child,{__index = parent}) end

-- Добавление маски столкновения (Спрайт, Смешение по Х, Смешение по Y)
function add_mask(spr, mask_x, mask_y)
	local add_mask = {}
	add_mask.x = mask_x or 0
	add_mask.y = mask_y or 0
	add_mask.sprite_index = spr
	add_mask.w = spr:getWidth() * ratio
	add_mask.h = spr:getHeight() * ratio
	add_mask.xoffset = add_mask.w*.5
	add_mask.yoffset = add_mask.h*.5
	return add_mask
end

---- Debug Отрисовка
function draw_mask(_mask, _obj)
	love.graphics.draw(_mask.sprite_index, (_obj.x + _mask.x) - _mask.xoffset, (_obj.y + _mask.y) - _mask.yoffset)
end

function draw_mask_outline(_mask, _obj)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.rectangle("line", (_obj.x + _mask.x) - _mask.xoffset, (_obj.y + _mask.y) - _mask.yoffset, _mask.w, _mask.h)
	love.graphics.setColor(1, 1, 1, 1)
end

function draw_sprite_outline(_spr, _obj)
	love.graphics.setColor(1, 1, 1, 1)
	local w = _spr:getWidth()
	local h = _spr:getHeight()
	local xoffset = w*.5
	local yoffset = h*.5
	love.graphics.rectangle("line", _obj.x - xoffset, _obj.y - yoffset, w, h)
end

function draw_sheet_outline(_spr, _obj)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", _obj.x - _spr.frame_xoffset, _obj.y - _spr.frame_xoffset, _spr.frame_w, _spr.frame_h)
end

-- UI
function draw_sclice(spr, quad, x1, y1, x2, y2, scale)
	local _scale = scale or 1
	local _size = (spr:getWidth()*_scale) / 3
	local _x1 = x1
	local _y1 = y1
	local _x2 = x2
	local _y2 = y2

	local _w = (_x2 - _x1)
	local _h = (_y2 - _y1)

	local scale_w = (_w - (_size * 2)) * 0.125
	local scale_h = (_h - (_size * 2)) * 0.125

	-- MIDLE
	love.graphics.draw(spr, quad.frames[5], _x1 + _size, _y1 + _size, 0, scale_w, scale_h)

	-- EDGES
	-- left edge
	love.graphics.draw(spr, quad.frames[4], _x1, _y1 + _size, 0, _scale, scale_h)
	-- right edge
	love.graphics.draw(spr, quad.frames[6], _x1 + _w - _size, _y1 + _size, 0, _scale, scale_h)
	-- top edge
	love.graphics.draw(spr, quad.frames[2], _x1 + _size, _y1, 0, scale_w , _scale)
	-- bottom edge
	love.graphics.draw(spr, quad.frames[8], _x1 + _size, _y1 + _h - (_size), 0, scale_w, _scale)

	-- CORNERS
	-- top left
	love.graphics.draw(spr, quad.frames[1], _x1, _y1, 0, _scale, _scale)
	-- top right
	love.graphics.draw(spr, quad.frames[3], _x1 + _w - _size, _y1, 0, _scale, _scale)
	--bottom left
	love.graphics.draw(spr, quad.frames[7], _x1, _y1 + _h - _size, 0, _scale, _scale)
	-- bootom right
	love.graphics.draw(spr, quad.frames[9], _x1 + _w - _size, _y1 + _h -_size, 0, _scale, _scale)
end
