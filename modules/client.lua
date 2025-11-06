local module = {}

function module.draw(pid)
    local x, y, z = player.get_pos(pid)
    local data = block.raycast({x, y+0.75, z}, player.get_dir(pid), 4)
    if not data then return end

    hud.show_overlay("taketag:paint", false)
end

return module