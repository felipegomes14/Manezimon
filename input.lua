local inputModule = {}
local battleModule = require("battle")

local justEnteredMenu = false

function inputModule.handle(key, gameState, battle)

	if gameState ~= "battle" then return end

	if battleModule.isWaiting() then return end

	-- FINAL DA BATALHA
	if battle.state == "end" then
		if key == "return" then
			return battleModule.finishBattle(battle.result)
		end
		return
	end

	-- ================= MENU =================
	if battle.state == "menu" then

		if key == "w" then
			battle.selectedOption = battle.selectedOption - 1
			if battle.selectedOption < 1 then
				battle.selectedOption = #battle.options
			end
		end

		if key == "s" then
			battle.selectedOption = battle.selectedOption + 1
			if battle.selectedOption > #battle.options then
				battle.selectedOption = 1
			end
		end

		if key == "return" then
			local option = battle.options[battle.selectedOption]

			if option == "Atacar" then
				battle.state = "attack_menu"
				battle.selectedMove = 1
				justEnteredMenu = true

			elseif option == "Fugir" then
				battle.result = "flee"
				battle.state = "end"
			end
		end
	end

	-- ================= ATAQUE =================
	if battle.state == "attack_menu" then

		if justEnteredMenu then
			justEnteredMenu = false
			return
		end

		if key == "w" then
			battle.selectedMove = battle.selectedMove - 1
			if battle.selectedMove < 1 then
				battle.selectedMove = #battle.player.moves
			end
		end

		if key == "s" then
			battle.selectedMove = battle.selectedMove + 1
			if battle.selectedMove > #battle.player.moves then
				battle.selectedMove = 1
			end
		end

		if key == "return" then
			battleModule.playerAttack(battle.player.moves[battle.selectedMove])
		end

		if key == "backspace" then
			battle.state = "menu"
		end
	end
end

return inputModule