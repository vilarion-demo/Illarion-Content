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
-- INSERT INTO scheduledscripts VALUES ('quest.irundar.maze', 15, 15, 'createIrundarMaze');

module("quest.irundar.maze", package.seeall)

function createIrundarMaze()
    -- dX and dY should be even
    local minX = 337
    local maxX = 361
    local minY = 512
    local maxY = 542
    local level = -23
    local wallItemId = 287
    
    local dx = maxX - minX
    local dy = maxY - minY
    
    local maze = {}
    
    -- create filled maze
    -- add imaginary outer walls (just for calculation, should be placed on map where needed and remain fixed)
    for x = minX - 1, maxX + 1 do
        maze[x] = {}
       
        for y = minY - 1, maxY + 1 do
            maze[x][y] = true
        end
    end
    
    -- draw initial position from grid in given boundaries, omitting every second coordinate
    -- these potential positions are "rooms" in the maze, we will later open "doors"
    local roomsXRange = (dx + 2)/2
    local roomsYRange = (dy + 2)/2
    local numberOfRooms = roomsXRange * roomsYRange
    local currentPosition = {x = math.random(roomsXRange)*2 + minX - 2, y = math.random(roomsYRange)*2 + minY - 2}
    maze[currentPosition.x][currentPosition.y] = false
    
    local stack = {}
    local top = -1
    local visitedRooms = 1
    
    -- open doors, consider every possible room
    while visitedRooms < numberOfRooms do
        local adjacentRooms = {}
        local numberOfAdjacentRooms = 0
        
        -- can we decrease x by 2 to visit an adjacent room?
        if currentPosition.x - 2 >= minX then
        
            -- does the adjacent room have doors? If not, we have not been there yet!
            if maze[currentPosition.x - 1][currentPosition.y] and maze[currentPosition.x - 3][currentPosition.y] and
                    maze[currentPosition.x - 2][currentPosition.y + 1] and maze[currentPosition.x - 2][currentPosition.y - 1] then
                numberOfAdjacentRooms = numberOfAdjacentRooms + 1
                adjacentRooms[numberOfAdjacentRooms] = {x = currentPosition.x - 2, y = currentPosition.y, doorOffsetX = 1, doorOffsetY = 0}
            end
        end
        
        -- can we increase x by 2 to visit an adjacent room?
        if currentPosition.x + 2 <= maxX then
        
            -- does the adjacent room have doors? If not, we have not been there yet!
            if maze[currentPosition.x + 1][currentPosition.y] and maze[currentPosition.x + 3][currentPosition.y] and
                    maze[currentPosition.x + 2][currentPosition.y + 1] and maze[currentPosition.x + 2][currentPosition.y - 1] then
                numberOfAdjacentRooms = numberOfAdjacentRooms + 1
                adjacentRooms[numberOfAdjacentRooms] = {x = currentPosition.x + 2, y = currentPosition.y, doorOffsetX = -1, doorOffsetY = 0}
            end
        end
        
        -- can we decrease y by 2 to visit an adjacent room?
        if currentPosition.y - 2 >= minY then
        
            -- does the adjacent room have doors? If not, we have not been there yet!
            if maze[currentPosition.x][currentPosition.y - 1] and maze[currentPosition.x][currentPosition.y - 3] and
                    maze[currentPosition.x - 1][currentPosition.y - 2] and maze[currentPosition.x + 1][currentPosition.y - 2] then
                numberOfAdjacentRooms = numberOfAdjacentRooms + 1
                adjacentRooms[numberOfAdjacentRooms] = {x = currentPosition.x, y = currentPosition.y - 2, doorOffsetX = 0, doorOffsetY = 1}
            end
        end
        
        -- can we increase y by 2 to visit an adjacent room?
        if currentPosition.y + 2 <= maxY  then
        
            -- does the adjacent room have doors? If not, we have not been there yet!
            if maze[currentPosition.x][currentPosition.y + 1] and maze[currentPosition.x][currentPosition.y + 3] and
                    maze[currentPosition.x - 1][currentPosition.y + 2] and maze[currentPosition.x + 1][currentPosition.y + 2] then
                numberOfAdjacentRooms = numberOfAdjacentRooms + 1
                adjacentRooms[numberOfAdjacentRooms] = {x = currentPosition.x, y = currentPosition.y + 2, doorOffsetX = 0, doorOffsetY = -1}
            end
        end
        
        if numberOfAdjacentRooms > 0 then
            -- if there are undiscovered adjacent rooms, visit one at random
            local i = math.random(numberOfAdjacentRooms)
            
            -- create a door to the room we will visit next
            maze[adjacentRooms[i].x + adjacentRooms[i].doorOffsetX][adjacentRooms[i].y + adjacentRooms[i].doorOffsetY] = false
            
            -- put the current room onto the stack so that we can go back later
            top = top + 1
            stack[top] = {x = currentPosition.x, y = currentPosition.y}
            
            -- visit the selected adjacent room and make sure it is not blocked
            currentPosition.x = adjacentRooms[i].x
            currentPosition.y = adjacentRooms[i].y
            maze[currentPosition.x][currentPosition.y] = false
            
            visitedRooms = visitedRooms + 1
        else
            -- if there are no undiscovered adjacent rooms, go back to where we came from
            currentPosition.x = stack[top].x
            currentPosition.y = stack[top].y
            top = top - 1
        end
    end
    
    -- build maze on map
    for x = minX, maxX do
        for y = minY, maxY do
            local currentPosition = position(x, y, level)
            local isWallOnField = world:isItemOnField(currentPosition) and world:getItemOnField(currentPosition).id == wallItemId
            
            -- only create/delete wall if it really changes
            if isWallOnField ~= maze[x][y] then
                if maze[x][y] then
                    world:createItemFromId(wallItemId, 1, currentPosition, true, 999, nil)
                else
                    world:erase(world:getItemOnField(currentPosition), 1)
                end
            end
        end
    end
end
