--[[
Illarion Server

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
local common = require("base.common")
local playerlookat = require("server.playerlookat")
local lookat = require("base.lookat")

local M = {}
-- belongs also to item id 2873

-- UPDATE items SET itm_script='item.id_2874_mirror' WHERE itm_id = 2874;

local ladderPosition = position(-32,193,-8)
local mirrorPosition = position(-28,193,-8)

function M.LookAtItem(User, Item)
    local lookAt = lookat.GenerateLookAt(User, Item)

    lookAt = quest.irundar.mirror.LookAt(User, Item, lookAt)
    
    return lookAt
end

function M.UseItem(User, SourceItem)
    local output = playerlookat.getCharDescription( User, User, 2);
    -- 2 means mode mirror
    common.TurnTo( User, SourceItem.pos );
    User:inform(output);
end

return M

