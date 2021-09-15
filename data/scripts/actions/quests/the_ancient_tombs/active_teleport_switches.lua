local config = {
	[11165] = GlobalStorage.TheAncientTombs.ThalasSwitchesGlobalStorage,
	[11166] = GlobalStorage.TheAncientTombs.DiprathSwitchesGlobalStorage,
	[11167] = GlobalStorage.TheAncientTombs.AshmunrahSwitchesGlobalStorage
}

local function resetScript(position, storage)
	local item = Tile(position):getItemById(2773)
	if item then
		item:transform(2772)
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) - 1)
end

local theAncientActiveTeleport = Action()
function theAncientActiveTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storage = config[item.actionid]
	if not storage then
		return true
	end

	if item.itemid ~= 2772 then
		return false
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) + 1)
	item:transform(2773)
	addEvent(resetScript, 20 * 60 * 1000, toPosition, storage)
	return true
end

theAncientActiveTeleport:aid(12121,11166,11167)
theAncientActiveTeleport:register()