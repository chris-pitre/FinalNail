extends Node3D


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("lmb"):
		SignalBus.toggle_level_up.emit()
