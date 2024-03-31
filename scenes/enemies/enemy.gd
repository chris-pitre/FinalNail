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
@onready var movelist := $Movelist

@export var anim: AnimationPlayer = null
@export var enemy_name: String = "Dummy"
@export var max_hp: int = 20
var hp: int
# Composition, Spirit, Corpus, Premonition, Piety
@export var stats: Array[int] = [5, 5, 5, 5, 5]
@export_flags("Blunt:1", "Slashing:2", "Piercing:4", "Magic:8") var resists = 0

func _ready():
	SignalBus.player_pos_updated.connect(_check_for_player)
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

func _check_for_player(x, y):
	for raycast in movecasts.get_children():
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.owner is Player:
				var instant_move = Player.move_instant
				Player.move_instant = false
				BattleManager.start_battle(self)
				SignalBus.player_check_enemy.emit()
				while(not PlayerData.enemy_sighted):
					var dot_product = to_global(raycast.target_position).dot(PlayerData.facing)
					if dot_product >= 1 or dot_product <= -1:
						SignalBus.rotate_player.emit(true)
					else:
						SignalBus.rotate_player.emit(dot_product > 0)
					await SignalBus.player_dir_updated
				Player.move_instant = instant_move

func take_damage(damage: int, spirit: int, skill_damage: int):
	var dmg_effectiveness = pow(1.05, (spirit - stats[2]))
	var resist = 0.5 if (damage & resists) == 1 else 1.0
	var actual_dmg = floor(dmg_effectiveness * skill_damage * resist) + 1
	hp -= actual_dmg
	if anim != null:
		play_animation("hit")
	if resist == 0.5:
		SignalBus.message_show.emit("%s resisted some of the attack" % [enemy_name], 1)
	else: 
		SignalBus.message_show.emit("%s took the full brunt of the attack" % [enemy_name], 1)
	await get_tree().create_timer(1).timeout
	SignalBus.message_show.emit("%s received %d damage" % [enemy_name, actual_dmg], 2, true)
	await get_tree().create_timer(2).timeout
	if hp <= 0:
		SignalBus.message_show.emit("%s has been slain" % [enemy_name], 2, true)
		BattleManager.end_battle(true)
		queue_free()
	else:
		BattleManager.player_turn_end.emit()
	

func do_turn():
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
