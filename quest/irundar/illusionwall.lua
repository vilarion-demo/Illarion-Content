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
-- INSERT INTO triggerfields VALUES (287, 537, -20, 'quest.irundar.illusionwall');

local common = require("base.common")
local M = {}

local destination = position(312, 543, -25)

function M.MoveToField(user)
        common.InformNLS(user, "Die solide aussehende Höhlenwand war anscheinend nur eine \z
                                Illusion und du stolperst in einen hell erleuchteten Korridor.",

                               "Apparently the solid seeming cave wall was just an \z
                                illusion and you stumble into a well-lit corridor.")

        user:warp(destination)
end

return M
