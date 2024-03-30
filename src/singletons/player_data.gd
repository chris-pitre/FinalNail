extends Node

signal health_changed(health, max_health)
signal stat_changed(stat: String, amount: int)
signal item_used(item_name: String, amt_left: int)
signal added_note()

enum STAT {
	COMPOSITION,
	SPIRIT,
	CORPUS,
	PREMONITION,
	PIETY,
}

var found_notes: Array[String] = ["Days in the labyrinth: 327,334"]
var health: int = 100:
	set = _set_health
var max_health: int = 100
var items: Dictionary = {}
var stats: Array[int] = [10, 10, 10, 10, 10]


func _set_health(amount: int) -> void:
	health = amount
	health_changed.emit(health, max_health)


func _set_max_health(amount: int) -> void:
	max_health = amount
	health_changed.emit(health, max_health)


func set_stat(stat: STAT, amount: int) -> void:
	stats[stat] = amount


func add_item(item_id: String, amt: int) -> void:
	items[item_id] += amt


func use_item(item_id: String) -> void:
	if items[item_id] > 0:
		match item_id:
			"soulvial":
				health = max_health
		items[item_id] -= 1
		item_used.emit(item_id, items[item_id])


func add_note(text: String) -> void:
	found_notes.append(text)
	added_note.emit()


func save_data() -> void:
	pass

func load_data() -> void:
	pass
