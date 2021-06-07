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

local doors = require("base.doors")
local keys = require("base.keys")
local M = {}

local doorsToClose = {}

-- a door is open for cycles*t to (cycles+1)*t, where t is the interval of the calling scheduled script (t = 30s).
local cycles = 2

local function addClosingDoor(x, y, z)
    table.insert(doorsToClose,{pos = position(x, y, z), countdown = cycles})
end

addClosingDoor(319, 480, -24) -- north-western castle dining room exit, always locked
addClosingDoor(332, 537, -23) -- arch-mage's chamber, always locked
addClosingDoor(320, 538, -25) -- gate
addClosingDoor(307, 520, -25) -- blacksmith
addClosingDoor(308, 520, -25) -- blacksmith
addClosingDoor(327, 538, -25) -- mage tower
addClosingDoor(327, 539, -25) -- mage tower

function M.lockDoors()
    for _, closingDoor in ipairs(doorsToClose) do
        local doorPos = closingDoor.pos

        if world:isItemOnField(doorPos) then
            if closingDoor.countdown == 0 then
                local door = world:getItemOnField(doorPos)

                if doors.CheckOpenDoor(door.id) then
                    doors.CloseDoor(door)
                    door = world:getItemOnField(doorPos)
                end

                if doors.CheckClosedDoor(door.id) then
                    keys.LockDoor(door)
                end

                closingDoor.countdown = cycles
            else
                closingDoor.countdown = closingDoor.countdown - 1
            end
        end
    end
end

return M
