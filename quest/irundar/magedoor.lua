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
-- INSERT INTO npc VALUES (2, 61, 334, 538, -26, 0, false, '', 'quest.irundar.magedoor');

-- Opens the mage tower with keyword Lothlendar

local doors = require("base.doors")
local keys = require("base.keys")
local M = {}

local leftDoor = position(327, 538, -25)
local rightDoor = position(327, 539, -25)

local function unlockAndOpen(doorPosition)
    local door = world:getItemOnField(doorPosition)
    keys.UnlockDoor(door)
    door = world:getItemOnField(doorPosition)
    doors.OpenDoor(door)
end

function M.receiveText(npc, textType, text, speaker)
    local pos = speaker.pos

    -- around mage tower doors
    if pos.z == leftDoor.z and
            pos.x >= leftDoor.x - 4 and pos.x <= leftDoor.x + 6 and
            pos.y >= leftDoor.y - 4 and pos.y <= leftDoor.y + 6 and
            string.find(text, "[Ll][Oo][Tt][Hh][Ll][Ee][Nn][Dd][Aa][Rr]") then
        unlockAndOpen(leftDoor)
        unlockAndOpen(rightDoor)
    end
end

return M
