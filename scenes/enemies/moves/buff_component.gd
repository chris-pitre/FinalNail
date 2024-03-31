class_name BuffComponent
extends Node3D

@export var enemy: Enemy
@export var target_player: bool = true
@export var amount: int = 2
@export var stat: PlayerData.STAT
@export var active: bool = false

signal complete

func execute():
	if not active:
		complete.emit()
		return true
	var stat_string: String
	match stat:
		PlayerData.STAT.COMPOSITION:
			stat_string = "composition"
		PlayerData.STAT.SPIRIT:
			stat_string = "spirit"
		PlayerData.STAT.CORPUS:
			stat_string = "corpus"
		PlayerData.STAT.PREMONITION:
			stat_string = "premonition"
		PlayerData.STAT.PIETY:
			stat_string = "piety"
	
	if target_player:
		amount *= -1
		PlayerData.change_stat(stat, amount)
		SignalBus.message_show.emit("You feel your %s drain away..." % [stat_string], 2, true)
	else:
		enemy.change_stat(stat, amount)
		SignalBus.message_show.emit("%s focuses its shape improving its %s" % [enemy.enemy_name, stat_string], 2, true)
	await get_tree().create_timer(2).timeout
	return true
