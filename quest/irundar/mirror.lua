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

require("base.common")

module("quest.irundar.mirror", package.seeall)

ladderId = 35
ladderPosition = position(330, 536, -24)
userPosition = position(333, 536, -24)
mirrorPosition = position(334, 536, -24)
destinationPosition = position(330, 536, -23)

function LookAt(user, item, lookAt)
    if item.pos == mirrorPosition then
        if user:getFaceTo() == Character.dir_east and user.pos == userPosition then
            lookAt.description = base.common.GetNLS(user,
                    "Hinter deinem R�cken erkennst du deutlich eine Leiter im Spiegel.",
                    "Behind your back you can clearly see a ladder in the mirror.")
        
            if not base.common.isItemIdInFieldStack(ladderId, ladderPosition) then
                world:createItemFromId(ladderId, 1, ladderPosition, true, 999, nil)
            end
        else
            lookAt.description = base.common.GetNLS(user,
                    "Im Spiegel is eine seltsame Reflektion zu sehen.",
                    "The mirror shows a strange reflection.")
        end
    end
	
    return lookAt
end

function MoveToField(user)
    if user.pos == ladderPosition and base.common.isItemIdInFieldStack(ladderId, ladderPosition) then
        user:warp(destinationPosition)
    end
end

function MoveFromField(user)
    if user.pos == userPosition then
        removeLadder(user)
    end
end

function removeLadder(user)
    if base.common.isItemIdInFieldStack(ladderId, ladderPosition)  then
	    base.common.InformNLS(user, "Als du dich entfernst ist die Leiter verschwunden.", "As you turn away, the ladder has vanished.")
        base.common.removeItemIdFromFieldStack(ladderId, ladderPosition)
    end
end