local utils = {}

function utils.table_equals(tbl1, tbl2)
    if table.count_pairs(tbl1) ~= table.count_pairs(tbl2) then
        return false
    end

    for key, value in pairs(tbl1) do
        if value ~= tbl2[key] then
            return false
        end
    end

    return true
end

function utils.genRandomName(length)
    local chars = "abcdefghijklmnopqrstuvwxyz"
    local result = ""

    for _ = 1, length do
        local random_index = random.random(1, #chars)
        result = result .. chars:sub(random_index, random_index)
    end

    return result
end

function utils.getParameters(normal, pos, conf)
    local eq = utils.table_equals
    local offset = 0.005
    if eq(normal, {1, 0, 0}) then
        return {
            pos[1]+1+offset,
            pos[2]+conf,
            pos[3]+conf
        }, mat4.rotate({0, 1, 0}, 90)
    elseif eq(normal, {-1, 0, 0}) then
        return {
            pos[1]-offset,
            pos[2]+conf,
            pos[3]+conf
        }, mat4.rotate({0, 1, 0}, -90)
    elseif eq(normal, {0, 0, 1}) then
        return {
            pos[1]+conf,
            pos[2]+conf,
            pos[3]+1+offset
        }, mat4.rotate({0, 1, 0}, 180)
    elseif eq(normal, {0, 0, -1}) then
        return {
            pos[1]+conf,
            pos[2]+conf,
            pos[3]-offset
        }, mat4.rotate({1, 1, 1}, 0)
    elseif eq(normal, {0, 1, 0}) then
        return {
            pos[1]+conf,
            pos[2]+1+offset,
            pos[3]+conf
        }, mat4.rotate({1, 0, 0}, 90)
    elseif eq(normal, {0, -1, 0}) then
        return {
            pos[1]+conf,
            pos[2]-offset,
            pos[3]+conf
        }, mat4.rotate({1, 0, 0}, 270)
    end
end

function utils.canvas()
    local canvas = {}
    canvas.__index = canvas

    function canvas.new()
        local self = setmetatable({}, canvas)

        self.storage = {}
        self.data = Canvas()

        return self
    end

    function canvas:set(x, y, r, g, b, a)
        self.data:set(x, y, r, g, b, a)
    end
end

function utils.intToBytes(num)
    local byte1 = bit.rshift(num, 24)
    local byte2 = bit.band(bit.rshift(num, 16), 0xFF)
    local byte3 = bit.band(bit.rshift(num, 8), 0xFF)
    local byte4 = bit.band(num, 0xFF)

    return {byte1, byte2, byte3, byte4}
end

return utils