class_name Interactable
extends Node3D

func _ready() -> void:
	SignalBus.player_pos_updated.connect(_player_pos_updated)

func _player_pos_updated(x: int, y: int) -> void:
	var player_global_pos = Vector3((x + 0.5) * 2, 1.0, (y + 0.5) * 2)
	if (global_position - player_global_pos).length() > 4:
		for collision in $Area3D.get_children():
			if collision is CollisionShape3D:
				collision.disabled = true
	else:
		for collision in $Area3D.get_children():
			if collision is CollisionShape3D:
				collision.disabled = false

func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action("lmb") and event.is_pressed():
		interact()

func interact() -> void:
	pass
