exploration = require("exploration")
battleModule = require("battle")
inputModule = require("input")
drawModule = require("draw")
encyclopedia = require("encyclopedia")

function initGame()

	

	wf = require "libraries/windfield"
	world = wf.newWorld(0, 0)

	camera = require "libraries/camera"
	cam = camera()

	anim8 = require "libraries/anim8"
	love.graphics.setDefaultFilter("nearest", "nearest")

	sti = require "libraries/sti"
	gameMap = sti("maps/testMap.lua")

	local mapWidth = gameMap.width * gameMap.tilewidth
	local mapHeight = gameMap.height * gameMap.tileheight

	gameState = "exploration"

	
	player = {}
	player.x = mapWidth / 2
	player.y = mapHeight - 100

	player.collider = world:newRectangleCollider(player.x, player.y, 50, 50)
	player.collider:setFixedRotation(true)
	player.speed = 250

	player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
	player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

	player.animations = {
		down  = anim8.newAnimation(player.grid('1-4', 1), 0.3),
		left  = anim8.newAnimation(player.grid('1-5', 4), 0.2),
		right = anim8.newAnimation(player.grid('1-5', 2), 0.2),
		up    = anim8.newAnimation(player.grid('1-5', 3), 0.3),
		idle  = anim8.newAnimation(player.grid('1-5', 5), 0.5)
	}
	player.anim = player.animations.down

	
	sprites = {}

	sprites.background = love.graphics.newImage("sprites/battle/background.png")

	sprites.battleMap = love.graphics.newImage("sprites/creatures/martim_pescador/catalogo.png")
	sprites.battleMap = love.graphics.newImage("sprites/creatures/catanhao/catalogo.png")
	sprites.battleMap = love.graphics.newImage("sprites/creatures/ra_manezinha/catalogo.png")
	sprites.battleMap = love.graphics.newImage("sprites/creatures/maruim/catalogo.png")

	sprites.playerSheet = love.graphics.newImage("sprites/creatures/martim_pescador/back.png")
	sprites.playerGrid = anim8.newGrid(32,32,sprites.playerSheet:getWidth(),sprites.playerSheet:getHeight())
	sprites.playerAnim = anim8.newAnimation(sprites.playerGrid('1-4',1),0.6)

	sprites.raSheet = love.graphics.newImage("sprites/creatures/ra_manezinha/front.png")
	sprites.raGrid = anim8.newGrid(16,16,sprites.raSheet:getWidth(),sprites.raSheet:getHeight())
	sprites.raAnim = anim8.newAnimation(sprites.raGrid('1-3',1),0.6)

	sprites.catSheet = love.graphics.newImage("sprites/creatures/catanhao/front.png")
	sprites.catGrid = anim8.newGrid(32,32,sprites.catSheet:getWidth(),sprites.catSheet:getHeight())
	sprites.catAnim = anim8.newAnimation(sprites.catGrid('1-2',1),0.6)

	sprites.martimSheet = love.graphics.newImage("sprites/creatures/martim_pescador/front.png")
	sprites.martimGrid = anim8.newGrid(32,32,sprites.martimSheet:getWidth(),sprites.martimSheet:getHeight())
	sprites.martimAnim = anim8.newAnimation(sprites.martimGrid('1-3',1),0.6)

	sprites.maruimSheet = love.graphics.newImage("sprites/creatures/maruim/front.png")
	sprites.maruimGrid = anim8.newGrid(32,32,sprites.maruimSheet:getWidth(),sprites.maruimSheet:getHeight())
	sprites.maruimAnim = anim8.newAnimation(sprites.maruimGrid('1-4',1),0.3)

	sprites.tainhaSheet = love.graphics.newImage("sprites/creatures/tainha/front.png")
	sprites.tainhaGrid = anim8.newGrid(32,32,sprites.tainhaSheet:getWidth(),sprites.tainhaSheet:getHeight())
	sprites.tainhaAnim = anim8.newAnimation(sprites.tainhaGrid('1-4',1),0.3)

	encyclopedia.load()

	hitEffect = {
		player = {timer=0},
		enemy = {timer=0}
	}

	typeChart = {
		fire = {grass=2, water=0.5, fire=0.5},
		water = {fire=2, grass=0.5, water=0.5},
		grass = {water=2, fire=0.5, grass=0.5},
		normal = {water=1, fire=1, grass=1, normal=1}
	}

	currentEnemyIndex = 1

	sounds = {}
	pcall(function()
		sounds.attack = love.audio.newSource("sounds/attack.wav","static")
		sounds.hit = love.audio.newSource("sounds/hit.wav","static")
		sounds.levelup = love.audio.newSource("sounds/levelup.wav","static")
	end)

	battle = {
		state="menu",
		selectedOption=1,
		selectedMove=1,
		options={"Atacar","Fugir"},
		log={},

		player={
			name="MARTIM PESCADOR",
			type="fire",
			hp=100,
			maxHp=100,
			attack=20,
			level=1,
			xp=0,
			xpToNext=50,

			moves={
				{name="Chama",power=20,type="fire"},
				{name="Investida",power=15,type="normal"},
				{name="Lança Chamas",power=30,type="fire"},
				{name="Ataque Rápido",power=12,type="normal"}
			}
		},

		enemy={
			id="ra_manezinha",
			name="RÃ MANEZINHA",
			type="grass",
			xpReward=25,
			moves={
				{name="Folha",power=18,type="grass"},
				{name="Investida",power=12,type="normal"}
			}
		},

		enemy2={
			id="catanhao",
			name="CATANHÃO",
			type="water",
			xpReward=30,
			moves={
				{name="Água",power=18,type="water"},
				{name="Bolha",power=30,type="water"}
			}
		},

		enemy3={
			id="martim_pescador",
			name="MARTIM PESCADOR",
			type="fire",
			xpReward=25,
			moves={
				{name="Chama",power=20,type="fire"},
				{name="Investida",power=15,type="normal"},
				{name="Lança Chamas",power=30,type="fire"},
				{name="Ataque Rápido",power=12,type="normal"}
			}
		},

		enemy4={
			id="maruim",
			name="MARUIM",
			type="normal",
			xpReward=25,
			moves={
				{name="sugar",power=20,type="fire"},
				{name="Investida",power=15,type="normal"},
				{name="irritar",power=30,type="fire"},
				{name="Ataque Rápido",power=12,type="normal"}
			}
		},

		enemy5={
			id="tainha",
			name="TAINHA",
			type="water",
			xpReward=25,
			moves={
				{name="afogar",power=20,type="water"},
				{name="Investida",power=15,type="normal"},
				{name="jato-dagua",power=30,type="water"},
				{name="Ataque Rápido",power=12,type="normal"}
			}
		}
	}

	battleModule.load(battle, typeChart, hitEffect, sounds)
end

function startBattle()
	gameState="battle"
	battle.state="menu"
	currentEnemyIndex = battleModule.start(currentEnemyIndex)
	battle.log={"Um inimigo apareceu!"}
end

function updateGame(dt)

	if gameState=="exploration" then
		exploration.update(dt)
	end

	battleModule.update(dt)

	for _,v in pairs(hitEffect) do
		if v.timer>0 then v.timer=v.timer-dt end
	end

	sprites.playerAnim:update(dt)
	sprites.raAnim:update(dt)
	sprites.catAnim:update(dt)
	sprites.martimAnim:update(dt)
	sprites.maruimAnim:update(dt)
	sprites.tainhaAnim:update(dt)
end

function drawGame()

	if gameState=="exploration" then
		love.graphics.setColor(1,1,1)

		cam:attach()

		if gameMap.layers["solo"] then gameMap:drawLayer(gameMap.layers["solo"]) end
		if gameMap.layers["sobre"] then gameMap:drawLayer(gameMap.layers["sobre"]) end
		player.anim:draw(player.spriteSheet,player.x,player.y,nil,2,nil,6,9)
		if gameMap.layers["secundaria"] then gameMap:drawLayer(gameMap.layers["secundaria"]) end


		cam:detach()
	else
		drawModule.drawBattle(battle, sprites, hitEffect)
	end

	if encyclopedia.open then
    drawModule.drawEncyclopedia(encyclopedia)
    end

	love.graphics.setColor(1,1,1)
end

function handleKey(key)

    
    if key == "space" and gameState == "exploration" then
        startBattle()
        return
    end

    local newState = inputModule.handle(key, gameState, battle)

    
    if newState == "exploration" then
        gameState = "exploration"
        return
    end
end