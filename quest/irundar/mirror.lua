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
                    "Hinter deinem Rücken erkennst du deutlich eine Leiter im Spiegel.",
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