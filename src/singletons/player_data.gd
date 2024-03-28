extends Node

signal health_changed(health, max_health)
signal stat_changed(stat: String, amount: int)

enum STAT {
	COMPOSITION,
	SPIRIT,
	CORPUS,
	PREMONITION,
	PIETY,
}

var found_notes: Array[String] = []
var health: int = 100:
	set = _set_health
var max_health: int = 100
var stats: Array[int] = [10, 10, 10, 10, 10]

func _set_health(amount: int) -> void:
	health = amount
	health_changed.emit(health, max_health)

func _set_max_health(amount: int) -> void:
	max_health = amount
	health_changed.emit(health, max_health)

func set_stat(stat: STAT, amount: int) -> void:
	stats[stat] = amount

func save_data() -> void:
	pass

func load_data() -> void:
	pass
