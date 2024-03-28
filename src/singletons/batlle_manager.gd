extends Node

func start_battle(player_first: bool):
	if player_first:
		player_turn()
	else:
		enemy_turn()
		
func player_turn():
	SignalBus.player_turn_start.emit()
	await SignalBus.player_turn_end
	enemy_turn()
	
func enemy_turn():
	SignalBus.enemy_turn_start.emit()
	await SignalBus.enemy_turn_end
	player_turn()
	
func end_battle(is_win: bool):
	pass
