class_name Item3D
extends Node3D

var item_id: String = ""
var amount: int = 1

func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action("lmb") and event.is_pressed():
		PlayerData.add_item(item_id, amount)
		Audio.play_sound("res://assets/sfx/itempickup.ogg", "SFX")
		$Area3D.mouse_exited.emit()
		queue_free()
