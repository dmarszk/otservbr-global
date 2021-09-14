local internalNpcName = "Klom Stonecutter"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 3,
	lookBody = 77,
	lookLegs = 68,
	lookFeet = 76,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onCreatureAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onCreatureDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

local playerTopic = {}
npcConfig.voices = {
	interval = 5000,
	chance = 50,
	{text = 'abc'} }
local quantidade = {}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	local player = Player(creature)
	if player then
		npcHandler:setMessage(MESSAGE_GREET, {"Greetings. A warning straight ahead: I don't like loiterin'. If you're not here to {help} us, you're here to waste my time. Which I consider loiterin'. Now, try and prove your {worth} to our alliance. ... ",
											  "I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an opportunity to help destroy the weird machines, pumping lava into the caves leading to the most dangerous enemies."})
		playerTopic[playerId] = 1
	end
	return true
end

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, the biggest problem we need to address are the ever charging {subterraneans} around here. And on top of that, there\'s the threat of the Lost, who quite made themselves at {home} in these parts.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Maintainin\' this whole operation, the dwarven involvement \'course. Don\'t know about them gnomes but if I ain\'t gettin\' those dwarves in line, there\'ll be chaos down here. I also oversee the {defences} and {counterattacks}.'})
keywordHandler:addKeyword({'defences'}, StdModule.say, {npcHandler = npcHandler, text = {'The attacks of the enemy forces are fierce but we hold our ground. ... ',
																						'I\'d love to face one of their generals in combat but as their masters they cowardly hide far behind enemy lines and I have other duties to fulfil. ... ',
																						'I envy you for the chance to thrust into the heart of the enemy, locking weapons with their jaws... or whatever... and see the fear in their eyes when they recognise they were bested.'}})
keywordHandler:addKeyword({'counterattacks'}, StdModule.say, {npcHandler = npcHandler, text = {'I welcome a fine battle as any dwarf worth his beard should do. As long as it\'s a battle against something I can hit with my trusty axe. ...',
																							  'But here the true {enemy} eludes us. We fight wave after wave of their lackeys and if the gnomes are right the true enemy is up to something far more sinister. '}})
keywordHandler:addKeyword({'enemy'}, StdModule.say, {npcHandler = npcHandler, text = {'I have no idea what kind of creeps are behind all this. Even the gnomes don\'t and they have handled that stuff way more often. ...',
																					 'But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it\'s our obligation to annihilate them.'}})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Klom Stonecutter\'s the name. '})

local function creatureSayCallback(npc, creature, type, message)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = creature:getId()
	npcHandler.topic[playerId] = playerTopic[playerId]
	local player = Player(creature)
	npc = Npc(creature)

	local tempo = 20*60*60

	-- missão subterraneans
	if msgcontains(message, "subterraneans") and npcHandler.topic[playerId] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) == 2 and player:getStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskSubterranean) > 0 then
			npcHandler:say({"I don't need your help for now. Come back later."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) == 2 and player:getStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskSubterranean) <= 0 then
			npcHandler:say({"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
							"Prepared to get rid of some seriously foul creepers for us?"}, npc, creature)
			playerTopic[playerId] = 2
			npcHandler.topic[playerId] = 2
		end
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"Vermin. Everywhere. We get a lot of strange four-legged crawlers and worms down here lately. It's getting out of hand and... well, I need a real killer for this. ",
							"Prepared to get rid of some seriously foul creepers for us?"}, npc, creature)
			playerTopic[playerId] = 2
			npcHandler.topic[playerId] = 2
		elseif (player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) == 1) and (player:getStorageValue(Storage.DangerousDepths.Dwarves.Organisms) < 50) then -- Está na missão porém não terminou a task!
			npcHandler:say({"Come back when you have finished your job."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		elseif (player:getStorageValue(Storage.DangerousDepths.Dwarves.Subterranean) == 1) and (player:getStorageValue(Storage.DangerousDepths.Dwarves.Organisms) >= 50) then
			npcHandler:say({"I'l say I'm blown away but a Klom Stonecutter is not that easily impressed. Still, your got your hands dirt for us and I appreciate that."}, npc, creature)
			-- Entregando surprise jar + 1 ponto de missão!
			player:setStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskSubterranean, os.time() + tempo)
			player:addItem(32014, 1)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, player:getStorageValue(Storage.DangerousDepths.Dwarves.Status) + 1)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Subterranean, 2)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif npcHandler.topic[playerId] == 2 and msgcontains(message, "yes") then
		npcHandler:say({"Alright, good. Those things are strolling about and I ain't gonna have that. If it moves more than two legs, destroy it. If it moves legs and tentacles, destroy it again."}, npc, creature)
		if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
		end
		player:setStorageValue(Storage.DangerousDepths.Dwarves.Subterranean, 1)
		player:setStorageValue(Storage.DangerousDepths.Dwarves.Organisms, 0) -- Garantindo que a task não inicie com -1
		playerTopic[playerId] = 1
		npcHandler.topic[playerId] = 1
	end

	-- missão home
	if msgcontains(message, "home") and npcHandler.topic[playerId] == 1 then
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 2 and player:getStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskHome) > 0 then
			npcHandler:say({"I don't need your help for now. Come back later."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 2 and player:getStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskHome) <= 0 then
			npcHandler:say({"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
							"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
							"Are you ready for that? "}, npc, creature)
			playerTopic[playerId] = 22
			npcHandler.topic[playerId] = 22
		end
		if player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) < 1 then -- Não possuía a missão, agora possui!
			npcHandler:say({"We need to find a way to drive off the exiles from these caves. Countless makeshift homes are popping up at every corner. Destroy them and get the Lost out of hiding to eliminate them. ... ",
							"If you can capture a few of them, you'll receive a bonus. Just bring 'em to the border of our outpost and we will take care of the rest. ... ",
							"Are you ready for that? "}, npc, creature)
			playerTopic[playerId] = 22
			npcHandler.topic[playerId] = 22
		elseif (player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.DangerousDepths.Dwarves.LostExiles) < 20 and player:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners) < 3) then -- Está na missão porém não terminou nenhuma das tasks!
			npcHandler:say({"Come back when you have finished your job."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		elseif (player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.DangerousDepths.Dwarves.LostExiles) >= 20 and player:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners) < 3) then
			npcHandler:say({"So you did it. Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!"}, npc, creature) -- Caso não tenha feito o task bônus
			-- Entregando surprise jar + 1 ponto de missão!
			player:setStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskHome, os.time() + tempo)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Home, 2)
			player:addItem(32014, 1)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, player:getStorageValue(Storage.DangerousDepths.Dwarves.Status) + 1)
			playerTopic[playerId] = 1
		npcHandler.topic[playerId] = 1
		elseif (player:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 1) and (player:getStorageValue(Storage.DangerousDepths.Dwarves.LostExiles) >= 20 and player:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners) >= 3) then
			npcHandler:say({"So you did it. And you even made prisoners, the bonus is yours! Well, that won't be the last of 'em but this sure helps our situation down here. Return to me later if you want to help me again!"}, npc, creature) -- Se tiver feito ambas
			-- Entregando 2 surprise jars + 2 pontos de missão!
			player:setStorageValue(Storage.DangerousDepths.Dwarves.TimeTaskHome, os.time() + tempo)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Home, 2)
			player:addItem(32014, 2) -- +1 item pela task bônus!
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, player:getStorageValue(Storage.DangerousDepths.Dwarves.Status) + 2) -- +1 ponto pela task bônus!
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif npcHandler.topic[playerId] == 22 and msgcontains(message, "yes") then
		npcHandler:say({"Very well, now try to find some of their makeshift homes and tear'em down. There's bound to be some stragglers you can 'persuade' to surrender, eliminate any resistance. Get back here when you're done."}, npc, creature)
			if player:getStorageValue(Storage.DangerousDepths.Questline) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Questline, 1)
			end
		player:setStorageValue(Storage.DangerousDepths.Dwarves.Home, 1)
		player:setStorageValue(Storage.DangerousDepths.Dwarves.LostExiles, 0) -- Garantindo que a task não inicie com -1
		player:setStorageValue(Storage.DangerousDepths.Dwarves.Prisoners, 0) -- Garantindo que a task não inicie com -1
		playerTopic[playerId] = 1
		npcHandler.topic[playerId] = 1
	end

	local plural = ""
	if msgcontains(message, "suspicious devices") or msgcontains(message, "suspicious device") then
		npcHandler:say({"If you bring me any suspicious devices on creatures you slay down here, I'll make it worth your while by telling the others of your generosity. How many do you want to offer? "}, npc, creature)
		playerTopic[playerId] = 55
		npcHandler.topic[playerId] = 55
	elseif npcHandler.topic[playerId] == 55 then
		quantidade[playerId] = tonumber(message)
		if quantidade[playerId] then
			if quantidade[playerId] > 1 then
				plural = plural .. "s"
			end
			npcHandler:say({"You want to offer " .. quantidade[playerId] .. " suspicious device" ..plural.. ". Which leader shall have it, (Gnomus) of the {gnomes}, (Klom Stonecutter) of the {dwarves} or the {scouts} (Lardoc Bashsmite)?"}, npc, creature)
			playerTopic[playerId] = 56
			npcHandler.topic[playerId] = 56
		else
			npcHandler:say({"Don't waste my time."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(message, "gnomes") and npcHandler.topic[playerId] == 56 then
		if player:getItemCount(30888) >= quantidade[playerId] then
			npcHandler:say({"Done."}, npc, creature)
			if quantidade[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[playerId] .." point"..plural.." on the gnomes mission.")
			player:removeItem(30888, quantidade[playerId])
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, player:getStorageValue(Storage.DangerousDepths.Gnomes.Status) + quantidade[playerId])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(message, "dwarves") and npcHandler.topic[playerId] == 56 then
		if player:getItemCount(30888) >= quantidade[playerId] then
			npcHandler:say({"Done."}, npc, creature)
			if quantidade[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[playerId] .." point"..plural.." on the dwarves mission.")
			player:removeItem(30888, quantidade[playerId])
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, player:getStorageValue(Storage.DangerousDepths.Dwarves.Status) + quantidade[playerId])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(message, "scouts") and npcHandler.topic[playerId] == 56 then
		if player:getItemCount(30888) >= quantidade[playerId] then
			npcHandler:say({"Done."}, npc, creature)
			if quantidade[playerId] > 1 then
				plural = plural .. "s"
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You earned ".. quantidade[playerId] .." point"..plural.." on the scouts mission.")
			player:removeItem(30888, quantidade[playerId])
			player:setStorageValue(Storage.DangerousDepths.Scouts.Status, player:getStorageValue(Storage.DangerousDepths.Scouts.Status) + quantidade[playerId])
		else
			npcHandler:say({"You don't have enough suspicious devices."}, npc, creature)
			playerTopic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	end

		-- Início checagem de pontos de tasks!!
	if msgcontains(message, "status") then
		npcHandler:say({"So you want to know what we all think about your deeds? What leader\'s opinion are you interested in, the {gnomes} (Gnomus), the {dwarves} (Klom Stonecutter) or the {scouts} (Lardoc Bashsmite)?"}, npc, creature)
		playerTopic[playerId] = 5
		npcHandler.topic[playerId] = 5
	elseif msgcontains(message, "gnomes") and npcHandler.topic[playerId] == 5 then
		npcHandler:say({'The gnomes are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Gnomes.Status), 0) .. '/10)'}, npc, creature)
	elseif msgcontains(message, "dwarves") and npcHandler.topic[playerId] == 5 then
		npcHandler:say({'The dwarves are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Dwarves.Status), 0) .. '/10)'}, npc, creature)
	elseif msgcontains(message, "scouts") and npcHandler.topic[playerId] == 5 then
		npcHandler:say({'The scouts are still in need of your help, member of Bigfoot\'s Brigade. Prove your worth by answering their calls! (' .. math.max(player:getStorageValue(Storage.DangerousDepths.Scouts.Status), 0) .. '/10)'}, npc, creature)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
