extends Node3D

func _ready() -> void:
	SignalBus.player_pos_updated.connect(_player_pos_updated)

func _player_pos_updated(x: int, y: int) -> void:
	var player_global_pos = Vector3((x + 0.5) * 2, 1.0, (y + 0.5) * 2)
	if (global_position - player_global_pos).length() > 2.5:
		$Area3D/CollisionShape3D.disabled = true
	else:
		$Area3D/CollisionShape3D.disabled = false

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("lmb"):
		SignalBus.toggle_level_up.emit()
