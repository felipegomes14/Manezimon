local exploration = {}

function exploration.update(dt)
	local vx,vy=0,0
	local moving=false

	if love.keyboard.isDown("d") then vx=vx+1 player.anim=player.animations.right moving=true end
	if love.keyboard.isDown("a") then vx=vx-1 player.anim=player.animations.left moving=true end
	if love.keyboard.isDown("s") then vy=vy+1 player.anim=player.animations.down moving=true end
	if love.keyboard.isDown("w") then vy=vy-1 player.anim=player.animations.up moving=true end

	local len=math.sqrt(vx*vx+vy*vy)
	if len>0 then
		vx=(vx/len)*player.speed
		vy=(vy/len)*player.speed
	end

	player.collider:setLinearVelocity(vx,vy)

	if not moving then player.anim=player.animations.idle end

	world:update(dt)

	player.x=player.collider:getX()
	player.y=player.collider:getY()

	player.anim:update(dt)

	local screenW = love.graphics.getWidth()
	local screenH = love.graphics.getHeight()

	local mapW = gameMap.width * gameMap.tilewidth
	local mapH = gameMap.height * gameMap.tileheight

	local halfW = screenW / 2
	local halfH = screenH / 2

	local camX = math.max(halfW, math.min(player.x, mapW - halfW))
	local camY = math.max(halfH, math.min(player.y, mapH - halfH))

	cam:lookAt(camX, camY)
end

return exploration