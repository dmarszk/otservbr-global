local teleports = {
	[547] = {position = Position(33672, 32228, 7) }, -- summer entry
	[548] = {position = Position(33584, 32208, 7) }, -- summer exit
	[549] = {position = Position(33675, 32148, 7) }, -- winter entry
	[550] = {position = Position(32354, 31248, 3) } -- winter exit
}

local courtTeleport = MoveEvent()

function courtTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for index, value in pairs(teleports) do
		if item.actionid == index then
			player:teleportTo(value.position)
		end
	end
end

courtTeleport:type("stepin")

for index, value in pairs(teleports) do
	courtTeleport:aid(index)
end

courtTeleport:register()
