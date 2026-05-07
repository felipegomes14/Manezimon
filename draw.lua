local drawModule = {}

-- ================= BOX =================
local function drawBox(x, y, w, h)
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle("fill", x+4, y+4, w, h, 6, 6)

    love.graphics.setColor(1,1,1,0.65)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)

    love.graphics.setColor(0,0,0,0.8)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 6, 6)

    love.graphics.setColor(1,1,1)
end

-- ================= BARRA =================
local function drawBar(x,y,w,h,val,max,r,g,b)
    val = val or 0
    max = max or 1

    local pct = math.max(0, math.min(val/max, 1))

    love.graphics.setColor(0.2,0.2,0.2,0.8)
    love.graphics.rectangle("fill",x,y,w,h,4,4)

    love.graphics.setColor(r,g,b,0.85)
    love.graphics.rectangle("fill",x,y,w*pct,h,4,4)

    love.graphics.setColor(0,0,0,0.6)
    love.graphics.rectangle("line",x,y,w,h,4,4)

    love.graphics.setColor(1,1,1)
end

-- ================= DRAW =================
function drawModule.drawBattle(battle, sprites, hitEffect)

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.setColor(1,1,1)

    -- fundo
    love.graphics.draw(
        sprites.background,
        0,0,0,
        screenW/sprites.background:getWidth(),
        screenH/sprites.background:getHeight()
    )

    local e = battle.currentEnemy

    local px,py = 180,540
    local ex,ey = 620,370

    if hitEffect.player.timer>0 then
        px=px+math.random(-3,3)
        py=py+math.random(-3,3)
    end

    if hitEffect.enemy.timer>0 then
        ex=ex+math.random(-3,3)
        ey=ey+math.random(-3,3)
    end

    -- sprites
    sprites.playerAnim:draw(sprites.playerSheet,px,py,0,3,3,16,16)

    if e==battle.enemy then
        sprites.raAnim:draw(sprites.raSheet,ex,ey,0,3,3,16,16)
    else
        sprites.catAnim:draw(sprites.catSheet,ex,ey,0,3,3,16,16)
    end

    -- ================= HUD PLAYER =================
    drawBox(40, screenH-200, 220, 80)

    love.graphics.setColor(0,0,0)
    love.graphics.print("MARTIM PESCADOR",55,screenH-185)
    love.graphics.print("Lv "..battle.player.level,180,screenH-185)

    drawBar(55,screenH-160,190,12,battle.player.hp,battle.player.maxHp,0.8,0.2,0.2)
    drawBar(55,screenH-145,190,6,battle.player.xp,battle.player.xpToNext,0.2,0.7,0.3)

    -- ================= HUD ENEMY =================
    drawBox(screenW-260, 40, 220, 60)

    love.graphics.setColor(0,0,0)
    love.graphics.print(e.name.." Lv "..(e.level or 1),screenW-245,55)

    drawBar(screenW-245,80,190,10,e.hp,e.maxHp,0.8,0.2,0.2)

    -- ================= HUD PRINCIPAL =================
    local hudW = 400
    local hudH = 110

    local hudX = screenW - hudW - 20
    local hudY = screenH - hudH - 20

    drawBox(hudX, hudY, hudW, hudH)

    love.graphics.setColor(0,0,0)

    -- LOG
    if battle.showLog then
        local y = hudY + 15
        for i = math.max(1,#battle.log-2), #battle.log do
            love.graphics.print(battle.log[i], hudX + 15, y)
            y = y + 18
        end
        return
    end

    -- MENU
    if battle.state=="menu" then
        love.graphics.print("Escolha:", hudX + 15, hudY + 10)

        for i,v in ipairs(battle.options) do
            local p=(i==battle.selectedOption) and "> " or "  "
            love.graphics.print(p..v, hudX + 15, hudY + 30 + i*18)
        end
    end

    -- MOVES
    if battle.state=="attack_menu" then
        love.graphics.print("Ataques:", hudX + 15, hudY + 10)

        local col1 = hudX + 15
        local col2 = hudX + 180

        for i,v in ipairs(battle.player.moves) do
            local p=(i==battle.selectedMove) and "> " or "  "

            local x = (i<=2) and col1 or col2
            local y = hudY + 35 + ((i-1)%2)*18

            love.graphics.print(p..v.name,x,y)
        end
    end

    love.graphics.setColor(1,1,1)
end

return drawModule