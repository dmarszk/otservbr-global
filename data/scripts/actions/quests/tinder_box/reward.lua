local tinderReward = Action()
function tinderReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(11494) >= os.time() then
		return player:sendCancelMessage("The pile of bones is empty.")
	end
	player:addItem(20357, 1)
	player:setStorageValue(11494, os.time() + 20 * 1768)
	return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a tinder box.")
end

tinderReward:uid(3263)
tinderReward:register()