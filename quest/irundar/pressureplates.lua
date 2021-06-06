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
-- INSERT INTO triggerfields VALUES (370, 522, -28, 'quest.irundar.pressureplates');
-- INSERT INTO triggerfields VALUES (370, 532, -28, 'quest.irundar.pressureplates');

local common = require("base.common")
local M = {}

local wallId = 287
local northernPlate = position(370, 522, -28)
local southernPlate = position(370, 532, -28)
local wallPosition = position(365, 527, -28)
local lockSound = 19
local unlockSound = 20

function M.MoveToField(user)
    world:makeSound(unlockSound, user.pos)

    if world:isCharacterOnField(southernPlate)
            and world:isCharacterOnField(northernPlate) then
        common.removeItemIdFromFieldStack(wallId, wallPosition)
    end
end


function M.MoveFromField(user)
    world:makeSound(lockSound, user.pos)

    if not common.isItemIdInFieldStack(wallId, wallPosition) then
        world:createItemFromId(wallId, 1, wallPosition, true, 333, nil)
    end
end

return M
