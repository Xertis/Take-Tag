local mp = require "not_utils:main".multiplayer.api.server
local utils = require "utils"
local canvasFile = require "canvas_file"
local module = {}

function module.spawn_graf(pid, block_pos, normal, name)
    local CONF = 0.5
    local player_pos = {player.get_pos(pid)}

    if vec3.distance(player_pos, block_pos) > 4 then
        return
    end

    local pos, matrix = utils.getParameters(normal, block_pos, CONF)

    local entity = entities.spawn("taketag:graffiti", pos)
    entity.transform:set_rot(matrix)

    entity.skeleton:set_texture("$0", name)
end

mp.events.on("taketag", "draw", function (client, bytes)
    local imageName = canvasFile.decode(bytes)

    local pid = client.player.pid
    local x, y, z = player.get_pos(pid)
    local raycast = block.raycast({x, y+0.75, z}, player.get_dir(pid), 4)
    if not raycast then return end

    module.spawn_graf(pid, raycast.iendpoint, raycast.normal, imageName)
end)