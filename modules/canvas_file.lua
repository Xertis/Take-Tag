local utils = require "utils"
local module = {}

local colorLookup = {}
for id, color in ipairs(COLOR_FILTERS) do
    colorLookup[color.value] = id
end

local function findColor(bytes)
    local strBytes = json.tostring(bytes)

    return colorLookup[strBytes]
end

function module.encode(canvas, size)
    local data = {
        size = {size[1], size[2]},
        pixels = {}
    }

    local pixels = data.pixels
    local width, height = size[1], size[2]

    pixels.width = width
    pixels.height = height

    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local pixel = canvas:at(x, y)
            local id = findColor(utils.intToBytes(pixel))

            pixels[#pixels + 1] = id
        end
    end

    return bjson.tobytes(data, true)
end

function module.decode(bytes)
    if not bytes or #bytes == 0 then
        error("Invalid bytes data")
    end

    local data = bjson.frombytes(bytes)
    if not data or not data.size or not data.pixels then
        error("Invalid data structure")
    end

    local canvas = Canvas(data.size)
    local width, height = data.size[1], data.size[2]
    local pixels = data.pixels

    if #pixels ~= width * height then
        error("Pixel data size mismatch")
    end

    local indx = 0
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            indx = indx + 1
            local colorId = pixels[indx]

            if colorId < 1 or colorId > #COLOR_FILTERS then
                colorId = 1
            end

            local colorFilter = COLOR_FILTERS[colorId]
            if colorFilter and colorFilter.value then
                local pixel = json.parse(colorFilter.value)
                canvas:set(x, y, unpack(pixel))
            end
        end
    end

    local name = utils.genRandomName(30)
    canvas:create_texture(name)
    canvas:update()

    return name
end

return module