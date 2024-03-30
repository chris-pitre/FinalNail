extends Node

signal battle_start()
signal battle_end()

signal player_turn_start()
signal player_turn_end()

signal enemy_turn_start()
signal enemy_turn_end()

var battle_active: bool = false

func start_battle(player_first: bool):
	battle_active = true
	battle_start.emit()
	SignalBus.message_show.emit("An intimidating figure blocks your path", 3)
	if player_first:
		player_turn()
	else:
		enemy_turn()
		
func player_turn():
	player_turn_start.emit()
	await player_turn_end
	enemy_turn()
	
func enemy_turn():
	enemy_turn_start.emit()
	await enemy_turn_end
	player_turn()
	
func end_battle(is_win: bool):
	battle_active = false
