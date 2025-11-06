local mp = require "not_utils:main".multiplayer.api.client
local canvasFile = require "canvas_file"

local dotSize = nil
local dotColor = nil

function close()
	local size = {500, 500}

	local src = document.canvas.data

	mp.events.send("taketag", "draw", canvasFile.encode(src, size))

	hud.close_inventory()
end

local function interpolation(vec_1, vec_2, conf)
	local temp = vec2.mul(vec2.sub(vec_2, vec_1), conf)
	return vec2.add(vec_1, temp)
end

local function onDisplay(displayBox, dot)
	if dot[1] < displayBox[1] or dot[2] < displayBox[2] then
		return false
	end

	if dot[1] > displayBox[3]-1 or dot[2] > displayBox[4]-1 then
		return false
	end

	return true
end

local oldPos = nil

function setSize(size)
	dotSize = size
end

function selectColor(value)
	dotColor = json.parse(value)
end

function on_open()

    document.filters.options = COLOR_FILTERS
    document.filters.value = "white"

	dotColor = json.parse(COLOR_FILTERS[1].value)

	dotSize = document.track.value
	local canvas = document.canvas.data
	local canvasSize = document.canvas.size

	canvas:create_texture("graf_paint")
	canvas:clear()
	canvas:update()

	document.root:setInterval(10, function ()
		if input.is_pressed("mouse:left") then
			local dot = input.get_mouse_pos()
			local root_pos = document.root.pos
			local confMin = 0

			if onDisplay({
				root_pos[1],
				root_pos[2],
				root_pos[1] + canvasSize[1],
				root_pos[2] + canvasSize[2]
			}, dot) then

				local origin = vec2.sub(dot, root_pos)
				origin = {
					math.floor(origin[1]),
					math.floor(origin[2])
				}

				if not oldPos then
					oldPos = origin
				end

				if dotSize > 25 then
					confMin = 100
				end

				for conf=confMin, 100 do
					conf = conf / 100
					local pos = interpolation(oldPos, origin, conf)
					for x=pos[1]-dotSize/2, pos[1]+dotSize/2 do
						for y=pos[2]-dotSize/2, pos[2]+dotSize/2 do
							if onDisplay({
								0,
								0,
								canvasSize[1],
								canvasSize[2]
							}, {x, y}) then
								canvas:set(x, y, unpack(dotColor))
							end
						end
					end
				end

				oldPos = origin
				canvas:update()
			end
		else
			oldPos = nil
		end
	end)
end
