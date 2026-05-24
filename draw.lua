local drawModule = {}
local battleModule = require("battle")

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

    local anim = battleModule.getAnimation()

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

    -- animação de ataque
    if anim.active then

        local progress =
            anim.timer / anim.duration

        local offset =
            math.sin(progress * math.pi) * 40

        if anim.attacker == "player" then
            px = px + offset
        end

        if anim.attacker == "enemy" then
            ex = ex - offset
        end
    end

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
    elseif e==battle.enemy2 then
        sprites.catAnim:draw(sprites.catSheet,ex,ey,0,3,3,22,16)
    elseif e==battle.enemy3 then
        sprites.martimAnim:draw(sprites.martimSheet,ex,ey,0,3,3,24,32)
    elseif e==battle.enemy4 then
        sprites.maruimAnim:draw(sprites.maruimSheet,ex,ey,0,3,3,20,32)
    elseif e==battle.enemy5 then
        sprites.tainhaAnim:draw(sprites.tainhaSheet,ex,ey,0,3,3,18,32)
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

-- ================= ENCICLOPEDIA =================
function drawModule.drawEncyclopedia(encyclopedia)

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill",0,0,sw,sh)

    love.graphics.setColor(1,1,1)

    love.graphics.print(
        "ENCICLOPEDIA - "
        .. encyclopedia.countSeen()
        .. "/"
        .. #encyclopedia.entries,
        40,
        30,
        0,
        2,
        2
    )

    local y = 100

    for i,v in ipairs(encyclopedia.entries) do

        local selected = (i == encyclopedia.selected)

        if selected then
            love.graphics.setColor(1,1,0.4)
        else
            love.graphics.setColor(1,1,1)
        end

        local name = v.seen and v.name or "?????"

        love.graphics.print(name,50,y)

        y = y + 40
    end

    local entry = encyclopedia.entries[encyclopedia.selected]

    if entry then

        love.graphics.setColor(1,1,1)

        if entry.seen then

            love.graphics.draw(
                entry.image,
                sw - 350,
                60,
                0,
                4,
                4
            )

            love.graphics.print(
                entry.name,
                sw - 350,
                320,
                0,
                2,
                2
            )

            love.graphics.print(
                "TIPO: "..entry.type,
                sw - 350,
                360
            )

            love.graphics.printf(
                entry.description,
                sw - 350,
                400,
                300
            )

        else

            love.graphics.print(
                "Criatura nao descoberta.",
                sw - 350,
                320
            )
        end
    end
end

return drawModule