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
-- INSERT INTO triggerfields VALUES (333, 538, -25, 'quest.irundar.armourladder');

local common = require("base.common")
local M = {}

local ladder = 35
local armourPosition = position(334, 535, -25)
local ladderPosition = position(333, 538, -25)
local destinationPosition = position(332, 539, -24)

function M.use(user, item)
    if item.pos == armourPosition then

        if not common.isItemIdInFieldStack(ladder, ladderPosition) then
            common.InformNLS(user, "Als du vorsichtig den Arm der Statue bewegst öffnet sich plötzlich \z
                                    eine Luke in der Decke und eine hölzerne Leiter fährt herab.",

                                   "As you carefully move the statue's arm, suddenly a hatch in the \z
                                    ceiling opens and a wooden ladder slides down.")

            world:createItemFromId(ladder, 1, ladderPosition, true, 999, nil)
        else
            common.InformNLS(user, "Nachdem du den verborgenen Schalter erneut betätigst gleitet \z
                                    die Leiter zurück in die Decke und die Luke schließt sich wieder.",

                                   "After moving the statue's arm once more, the ladder slides \z
                                    back into the ceiling and the hatch closes again.")

            common.removeItemIdFromFieldStack(ladder, ladderPosition)
        end
    end
end

function M.MoveToField( user )
    if common.isItemIdInFieldStack(ladder, ladderPosition) then
        user:warp(destinationPosition)
        common.removeItemIdFromFieldStack(ladder, ladderPosition)
    end
end

return M
