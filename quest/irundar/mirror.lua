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
-- INSERT INTO triggerfields VALUES (333, 536, -24, 'quest.irundar.mirror');
-- INSERT INTO triggerfields VALUES (330, 536, -24, 'quest.irundar.mirror');

local common = require("base.common")
local M = {}

local ladder = 35
local ladderPosition = position(330, 536, -24)
local userPosition = position(333, 536, -24)
local mirrorPosition = position(334, 536, -24)
local destinationPosition = position(330, 536, -23)

function M.LookAt(user, item, lookAt)
    if item.pos == mirrorPosition then
        if user:getFaceTo() == Character.dir_east and user.pos == userPosition then
            lookAt.description = common.GetNLS(user,
                    "Hinter deinem Rücken erkennst du deutlich eine Leiter im Spiegel.",
                    "Behind your back you can clearly see a ladder in the mirror.")

            if not common.isItemIdInFieldStack(ladder, ladderPosition) then
                world:createItemFromId(ladder, 1, ladderPosition, true, 999, nil)
            end
        else
            lookAt.description = common.GetNLS(user,
                    "Im Spiegel ist eine seltsame Reflektion zu sehen.",
                    "The mirror shows a strange reflection.")
        end
    end

    return lookAt
end

function M.MoveToField(user)
    if user.pos == ladderPosition and common.isItemIdInFieldStack(ladder, ladderPosition) then
        user:warp(destinationPosition)
    end
end

local removeLadder

function M.MoveFromField(user)
    if user.pos == userPosition then
        removeLadder(user)
    end
end

function removeLadder(user)
    if common.isItemIdInFieldStack(ladder, ladderPosition)  then
	    common.InformNLS(user, "Als du dich entfernst ist die Leiter verschwunden.", "As you turn away, the ladder has vanished.")
        common.removeItemIdFromFieldStack(ladder, ladderPosition)
    end
end

return M
