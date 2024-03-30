class_name Enemy
extends Node3D

@onready var movecasts := $MoveRaycasts

func _ready():
	SignalBus.player_pos_updated.connect(_check_for_player)

func _check_for_player(x, y):
	for raycast in movecasts.get_children():
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.owner is Player:
				BattleManager.start_battle(true)
