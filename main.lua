require("core")

function love.load()
	initGame()
end

function love.update(dt)
	updateGame(dt)
end

function love.draw()
	drawGame()
end

function love.keypressed(key)
	handleKey(key)
end