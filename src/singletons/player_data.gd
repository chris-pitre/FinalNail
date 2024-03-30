extends Node

signal health_changed(health, max_health)
signal stat_changed(stat: String, amount: int)
signal item_num_changed(item_id: String, amt_left: int)
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

var known_moves: Dictionary = {
	0b010101000: Callable(_attack_stab),
	0b000010101: Callable(_attack_stab),
	0b001010100: Callable(_attack_slash),
	0b100010001: Callable(_attack_slash),
	0b111101101: Callable(_attack_bash)
}

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
	item_num_changed.emit(item_id, items[item_id])


func use_item(item_id: String) -> void:
	if items[item_id] > 0:
		match item_id:
			"soulvial":
				health = max_health
		items[item_id] -= 1
		item_num_changed.emit(item_id, items[item_id])


func add_note(text: String) -> void:
	found_notes.append(text)
	added_note.emit()


func save_data() -> void:
	pass


func load_data() -> void:
	pass


func validate_attack(id) -> bool:
	var move = known_moves.get(id)
	if move != null:
		move.call()
		return true
	else:
		return false

func _attack_bash() -> void:
	print("bash")
	
func _attack_stab() -> void:
	print("stab")

func _attack_slash() -> void:
	print("slash")
