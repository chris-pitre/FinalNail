extends Interactable

var text: String = ""

func interact() -> void:
	PlayerData.add_note(text)
	Audio.play_sound("res://assets/sfx/flapoff.mp3", "SFX")
	$Area3D.mouse_exited.emit()
	queue_free()
