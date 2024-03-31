extends Node

signal health_changed(health, max_health)
signal stat_changed(stat: String, amount: int)
signal item_num_changed(item_id: String, amt_left: int)
signal added_note()
signal animation_played(anim_name: String)
signal player_died()
signal decrees_changed(decrees: int)

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
var items: Dictionary = {}
# Composition, Spirit, Corpus, Premonition, Piety
var stats: Array[int] = [10, 10, 10, 10, 10]
var decrees: int = 20
var enemy_sighted: bool = false
var facing: Vector3 = Vector3(0, 0, -2)

var known_moves: Dictionary = {
	0b010010010: ["Stab", Callable(_attack_stab)],
	0b000111000: ["Slash", Callable(_attack_slash)],
	0b111101101: ["Bash", Callable(_attack_bash)],
	0b010111010: ["Smite", Callable(_attack_smite)]
}

var decree_moves : Dictionary = {
	"Smite" : [Callable(_attack_smite), 10]
}

func _set_health(amount: int) -> void:
	health = amount
	health_changed.emit(health, max_health)
	if health <= 0:
		player_died.emit()


func _set_max_health(amount: int) -> void:
	max_health = amount
	health_changed.emit(health, max_health)

func set_decrees(amount: int) -> void:
	decrees = amount
	decrees_changed.emit(amount)

func change_stat(stat: STAT, amount: int) -> void:
	stats[stat] += amount
	SignalBus.player_stats_updated.emit()


func set_stat(stat: STAT, amount: int) -> void:
	stats[stat] = amount
	SignalBus.player_stats_updated.emit()


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

#could return array or null too lazy to configure proper return value lol
func validate_attack(id):
	var move = known_moves.get(id)
	return move


func take_damage(damage: int, spirit: int, skill_damage: int):
	var dmg_effectiveness = pow(1.05, (spirit - stats[2]))
	var actual_dmg = floor(dmg_effectiveness * skill_damage * 0.75) + 1
	health -= actual_dmg
	SignalBus.message_show.emit("You received %d damage" % [actual_dmg], 2, true)
	await get_tree().create_timer(2).timeout

func _attack_bash() -> void:
	BattleManager.hide_scroll.emit()
	animation_played.emit("bash")
	await get_tree().create_timer(0.5).timeout
	BattleManager.current_enemy.take_damage(BattleManager.DAMAGE.BLUNT, stats[1], 10)
	
	
func _attack_stab() -> void:
	BattleManager.hide_scroll.emit()
	animation_played.emit("stab")
	await get_tree().create_timer(0.8).timeout
	BattleManager.current_enemy.take_damage(BattleManager.DAMAGE.PIERCING, stats[1], 10)

func _attack_slash() -> void:
	BattleManager.hide_scroll.emit()
	animation_played.emit("slash")
	await get_tree().create_timer(0.5).timeout
	BattleManager.current_enemy.take_damage(BattleManager.DAMAGE.SLASHING, stats[1], 10)
	
func _attack_smite(penalty: int = 0) -> void:
	BattleManager.hide_scroll.emit()
	if decrees > 0:
		set_decrees(decrees - 1)
		SignalBus.message_show.emit("You call forth the power of your patron", 2, true)
		animation_played.emit("cast")
		await get_tree().create_timer(1.5).timeout
		BattleManager.current_enemy.take_damage(BattleManager.DAMAGE.MAGIC, stats[4], 30 - penalty)
	else:
		SignalBus.message_show.emit("You call for help but nobody listens", 2, true)
		animation_played.emit("cast")
		await get_tree().create_timer(1.5).timeout
		BattleManager.player_turn_end.emit()
