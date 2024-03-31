class_name Item3D
extends Interactable

var item_id: String = ""
var amount: int = 1

func interact() -> void:
	PlayerData.add_item(item_id, amount)
	Audio.play_sound("res://assets/sfx/itempickup.ogg", "SFX")
	$Area3D.mouse_exited.emit()
	queue_free()
