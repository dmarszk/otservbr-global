local removePositions = {
	fromPos = 28896,
	toPos = 28804
}

local closeId = 1270
local devilHelmetLever = Action()
function devilHelmetLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:remove(1)
	Game.createItem(closeId, 1, Position(32592, 32105, 14))
	Game.createItem(closeId, 1, Position(32592, 32106, 14))
	for i = removePositions.fromPos, removePositions.toPos do
		Tile(i, 12696, 14):getItemById(1271):remove()
	end
	return true
end

devilHelmetLever:aid(20594)
devilHelmetLever:register()