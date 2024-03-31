extends Node

signal battle_start()
signal battle_end()

signal player_turn_start()
signal player_turn_end()

signal enemy_turn_start()
signal enemy_turn_end()

signal hide_scroll()

enum TURNS{
	PLAYER,
	ENEMY
}

enum DAMAGE{
	BLUNT = 1,
	SLASHING = 2,
	PIERCING = 4,
	MAGIC = 8
}

var battle_active: bool = false
var current_turn: TURNS
var current_enemy: Enemy = null

func start_battle(enemy: Enemy):
	battle_active = true
	current_enemy = enemy
	SignalBus.message_show.emit("An intimidating figure blocks your path", 2)
	await get_tree().create_timer(2).timeout
	battle_start.emit()
	player_turn()
	
		
func player_turn():
	current_turn = TURNS.PLAYER
	SignalBus.message_show.emit("You ready your weapon", 1)
	player_turn_start.emit()
	await player_turn_end
	if battle_active:
		enemy_turn()
	
func enemy_turn():
	current_turn = TURNS.ENEMY
	enemy_turn_start.emit()
	await enemy_turn_end
	if battle_active:
		player_turn()
	
func end_battle(is_win: bool):
	battle_active = false
	player_turn_end.emit()
	battle_end.emit()
	if randf() >= 0.2:
		SignalBus.message_show.emit("You feel blessed by your patron...", 3)
		PlayerData.change_stat(PlayerData.STAT.PIETY, randi_range(1, 5))
