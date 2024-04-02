extends ColorRect

func _ready() -> void:
	SignalBus.won.connect(_won)

func _won() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "color:a", 1.0, 1)
	tween.tween_property(self, "color", Color.BLACK, 1)
	await tween.finished
	await show_message("Thanks for actually beating our game! That's pretty crazy.", 4.0)
	await show_message("This game was made by vextor, egg sandwich, and TemboJembo.", 4.0)
	await show_message("Bye!", 3.0)
	get_tree().quit()
	

func show_message(msg: String, time: float) -> void:
	$Label.text = msg
	await get_tree().create_timer(time).timeout
