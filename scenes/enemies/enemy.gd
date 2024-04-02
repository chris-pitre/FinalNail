class_name Enemy
extends Node3D

enum STAT {
	COMPOSITION,
	SPIRIT,
	CORPUS,
	PREMONITION,
	PIETY,
}

@onready var movecasts := $MoveRaycasts
@onready var move_raycast := $MoveRaycast
@onready var movelist := $Movelist

@export var damage_anim_name: String = "hit"
@export var is_lost_soul: bool = false
@export var can_move: bool = false
@export var anim: AnimationPlayer = null
@export var enemy_name: String = "Dummy"
@export var max_hp: int = 20
var hp: int
# Composition, Spirit, Corpus, Premonition, Piety
@export var stats: Array[int] = [5, 5, 5, 5, 5]
@export_flags("Blunt:1", "Slashing:2", "Piercing:4", "Magic:8") var resists = 0

var moving: bool = false
var player_found: bool = false
var last_player_pos: Vector3
var can_free: bool = false

func _ready():
	SignalBus.player_pos_updated.connect(_check_for_player)
	if can_move:
		SignalBus.player_pos_updated.connect(_do_movement)
	SignalBus.player_dir_updated.connect(face_player)
	BattleManager.enemy_turn_start.connect(do_turn)
	hp = max_hp
	if anim != null:
		anim.play("idle")

func change_stat(stat: PlayerData.STAT, amount: int) -> void:
	stats[stat] += amount


func set_stat(stat: PlayerData.STAT, amount: int) -> void:
	stats[stat] = amount

func face_player(is_right: bool):
	var dir = 1 if is_right else -1
	rotation -= Vector3(0, dir * (PI / 2), 0)

func _do_movement(x, y):
	if moving:
		return
		
	var rand_dir = randi_range(0, 3)
	
	var rand_dir_arr = [
		Vector3(0, 0, -2),
		Vector3(2, 0, 0),
		Vector3(0, 0, 2),
		Vector3(-2, 0, 0)
	]
	
	var success := false
	
	move_raycast.target_position = to_local(global_position + rand_dir_arr[rand_dir])
	move_raycast.force_raycast_update()
	
	if move_raycast.is_colliding():
		var collision = move_raycast.get_collider()
		if collision.owner is Cell:
			success = true
			slide(rand_dir_arr[rand_dir], success)

func slide(dir: Vector3, success: bool):
	moving = true		
		
	if player_found:
		return
	if Player.move_instant:
		global_position += dir
	elif not Player.move_instant:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(self, "global_position", global_position + dir, 0.15).finished
		
	global_position = Vector3(round(global_position.x), round(global_position.y), round(global_position.z))
	moving = false

func _check_for_player(x, y):
	var player_pos = Vector3(x * 2.0, 0.0, y * 2.0)
	last_player_pos = player_pos
	if player_pos == global_position + Vector3(0, 0, -2) or player_pos == global_position + Vector3(2, 0, 0) or player_pos == global_position + Vector3(0, 0, 2) or player_pos == global_position + Vector3(-2, 0, 0):
		player_found = true
		Player.input_queue.clear()
		var instant_move = Player.move_instant
		Player.move_instant = false
		BattleManager.start_battle(self)
		SignalBus.player_check_enemy.emit()
		while(not PlayerData.enemy_sighted):
			var dot_product = global_position.dot(PlayerData.facing)
			if dot_product >= 1 or dot_product <= -1:
				SignalBus.rotate_player.emit(true)
			elif dot_product == 0:
				break
			else:
				SignalBus.rotate_player.emit(dot_product > 0)
			await SignalBus.player_dir_updated
		Player.move_instant = instant_move

func take_damage(damage: int, spirit: int, skill_damage: int):
	var dmg_effectiveness = pow(1.05, (spirit - stats[2]))
	var resist = 0.5 if (damage & resists) >= 1 else 1.0
	var actual_dmg = floor(dmg_effectiveness * skill_damage * resist) + 1
	hp -= actual_dmg
	if anim != null:
		play_animation(damage_anim_name)
	if resist == 0.5:
		SignalBus.message_show.emit("%s resisted some of the attack" % [enemy_name], 1)
	else: 
		SignalBus.message_show.emit("%s took the full brunt of the attack" % [enemy_name], 1)
	await get_tree().create_timer(1).timeout
	SignalBus.message_show.emit("%s received %d damage" % [enemy_name, actual_dmg], 2, true)
	await get_tree().create_timer(2).timeout
	if not is_lost_soul and hp <= 0:
		die()
	elif is_lost_soul and hp <= 0:
		SignalBus.message_show.emit("The lost soul persists...", 2, true)
		Audio.play_sound("res://assets/sfx/ding.ogg", "SFX", 0.0, 0.2)
		await get_tree().create_timer(2).timeout
		can_free = true
		BattleManager.player_turn_end.emit()
	else:
		BattleManager.player_turn_end.emit()
	

func die():
	SignalBus.message_show.emit("%s has been slain" % [enemy_name], 2, true)
	await get_tree().create_timer(2).timeout
	BattleManager.end_battle(true)
	Audio.play_sound("res://assets/sfx/souldeath.ogg", "SFX")
	queue_free()

func free_soul():
	SignalBus.message_show.emit("%s has been captured" % [enemy_name], 2, true)
	await get_tree().create_timer(2).timeout
	BattleManager.end_battle(true)
	PlayerData.add_soul()
	queue_free()

func do_turn():
	if self == BattleManager.current_enemy:
		var sum_of_weights = 0
		for move in movelist.get_children():
			sum_of_weights += move.move_weight
		var roll = randf_range(0, sum_of_weights)
		for move in movelist.get_children():
			if roll < move.move_weight:
				if anim != null:
					play_animation("attack")
				move.execute()
				break
			roll -= move.move_weight

func play_animation(anim_name: String):
	anim.play(anim_name)
	await anim.animation_finished
	anim.play("idle")
