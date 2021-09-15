local mType = Game.createMonsterType("Minotaur Amazon")
local monster = {}

monster.description = "a minotaur amazon"
monster.experience = 2200
monster.outfit = {
	lookType = 608,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1045
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Underground Glooth Factory, Oramond Minotaur Camp, Oramond Dungeon."
	}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 21000
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 240,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I'll protect the herd!", yell = false},
	{text = "Never surrender!", yell = false},
	{text = "You won't hurt us!", yell = false}
}

monster.loot = {
	{id = 7368, chance = 3040, maxCount = 5},
	{id = 21204, chance = 19830},
	{id = 3031, chance = 100000, maxCount = 196},
	{id = 3582, chance = 60780},
	{id = 3577, chance = 4920},
	{id = 3035, chance = 62080, maxCount = 3},
	{id = 9058, chance = 290},
	{id = 5878, chance = 17950},
	{id = 239, chance = 7670},
	{id = 238, chance = 7380},
	{id = 11472, chance = 6800, maxCount = 2},
	{id = 3098, chance = 3040},
	{id = 3030, chance = 5500, maxCount = 2},
	{id = 9057, chance = 900, maxCount = 2},
	{id = 3033, chance = 970, maxCount = 2},
	{id = 3032, chance = 4050, maxCount = 2},
	{id = 21175, chance = 3040},
	{id = 21174, chance = 1740},
	{id = 5911, chance = 710},
	{id = 3039, chance = 430},
	{id = 3081, chance = 850},
	{id = 3037, chance = 870},
	{id = 3369, chance = 1160},
	{id = 7443, chance = 720}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 50},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -305, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 7, shootEffect = CONST_ANI_HUNTINGSPEAR, effect = CONST_ME_EXPLOSIONAREA, target = false},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 40, minDamage = -300, maxDamage = -400, radius = 4, shootEffect = CONST_ANI_THROWINGKNIFE, target = true},
	{name ="minotaur amazon paralyze", interval = 2000, chance = 15, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
