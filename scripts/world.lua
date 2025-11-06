local mp = require "not_utils:main".multiplayer
local mode = mp.mode

require "globals"

if mode == "standalone" or mode == "server" then
    require "server"
end