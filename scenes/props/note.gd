extends Node3D

var text: String = ""

func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action("lmb") and event.is_pressed():
		PlayerData.add_note(text)
		Audio.play_sound("res://assets/sfx/flapoff.mp3", "SFX")
		$Area3D.mouse_exited.emit()
		queue_free()
