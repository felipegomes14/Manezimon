local battleModule = {}

local battle
local typeChart
local hitEffect

local waitTimer = 0

function battleModule.load(b, t, h)
    battle = b
    typeChart = t
    hitEffect = h
end

function battleModule.isWaiting()
    return waitTimer > 0
end

function battleModule.update(dt)
    if waitTimer > 0 then
        waitTimer = waitTimer - dt
    else
        battle.showLog = false
    end
end

-- ================= START =================
function battleModule.start(index)

    battle.finished = false
    battle.showLog = true

    if index == 1 then
        battle.currentEnemy = battle.enemy
        index = 2
    else
        battle.currentEnemy = battle.enemy2
        index = 1
    end

    local e = battle.currentEnemy
    local lvl = math.random(1, battle.player.level+2)

    e.level = lvl
    e.maxHp = 80 + (lvl*10)
    e.hp = e.maxHp
    e.attack = 10 + (lvl*4)

    battle.log = {"Um inimigo apareceu!"}

    waitTimer = 1

    return index
end

-- ================= MULTIPLIER =================
local function getMult(a,d)
    if typeChart[a] and typeChart[a][d] then
        return typeChart[a][d]
    end
    return 1
end

-- ================= PLAYER ATTACK =================
function battleModule.playerAttack(move)

    if waitTimer > 0 then return end

    local e = battle.currentEnemy

    local mult = getMult(move.type, e.type)
    local dmg = math.floor((move.power + battle.player.attack) * mult)

    e.hp = e.hp - dmg
    if e.hp < 0 then e.hp = 0 end

    hitEffect.enemy.timer = 0.3

    local msg = "Voce usou "..move.name.." (-"..dmg..")"

    if mult > 1 then msg = msg.." SUPER EFETIVO!" end
    if mult < 1 then msg = msg.." NAO FOI MUITO EFETIVO..." end

    table.insert(battle.log, msg)

    battle.showLog = true
    waitTimer = 0.8

    if e.hp <= 0 then
        table.insert(battle.log,"Voce venceu!")
        battle.result = "win"
        battle.state = "end"
        return
    end

    -- inimigo responde
    battleModule.enemyAttack()
end

-- ================= ENEMY =================
function battleModule.enemyAttack()

    local e = battle.currentEnemy
    local m = e.moves[1]

    local mult = getMult(m.type, battle.player.type)
    local dmg = math.floor((m.power + e.attack) * mult)

    battle.player.hp = battle.player.hp - dmg
    if battle.player.hp < 0 then battle.player.hp = 0 end

    hitEffect.player.timer = 0.3

    local msg = e.name.." usou "..m.name.." (-"..dmg..")"

    if mult > 1 then msg = msg.." SUPER EFETIVO!" end
    if mult < 1 then msg = msg.." NAO FOI MUITO EFETIVO..." end

    table.insert(battle.log, msg)

    battle.showLog = true
    waitTimer = 0.8

    if battle.player.hp <= 0 then
        table.insert(battle.log,"Voce perdeu!")
        battle.result = "lose"
        battle.state = "end"
    end
end

-- ================= FINAL =================
function battleModule.finishBattle()

    if battle.finished then return "exploration" end
    battle.finished = true

    if battle.result == "win" then
        local xp = battle.currentEnemy.xpReward or 20

        -- ================= XP + LEVEL =================
        battle.player.xp = battle.player.xp + xp

        while battle.player.xp >= battle.player.xpToNext do
            battle.player.xp = battle.player.xp - battle.player.xpToNext
            battle.player.level = battle.player.level + 1

            battle.player.xpToNext = math.floor(battle.player.xpToNext * 1.25)

            -- bônus
            battle.player.maxHp = battle.player.maxHp + 10
            battle.player.attack = battle.player.attack + 3
            battle.player.hp = battle.player.maxHp

            table.insert(battle.log, "Subiu para o nivel "..battle.player.level.."!")
        end
    end

    -- reset player HP
    battle.player.hp = battle.player.maxHp

    -- reset estado
    battle.state = "menu"
    battle.selectedOption = 1
    battle.selectedMove = 1
    battle.result = nil

    return "exploration"
end

return battleModule