class_name Enemy
extends Node3D

@onready var movecasts := $MoveRaycasts
@export var max_hp: int = 20
var hp: int

func _ready():
	SignalBus.player_pos_updated.connect(_check_for_player)
	BattleManager.enemy_turn_start.connect(_do_turn)
	hp = max_hp
	
func _check_for_player(x, y):
	for raycast in movecasts.get_children():
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.owner is Player:
				BattleManager.start_battle(true)

func _take_damage(damage):
	hp -= damage

func _do_turn():
	pass
