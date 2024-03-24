extends TextureRect

@onready var needle := $CompassNeedle

func _ready():
	SignalBus.player_dir_updated.connect(_rotate_needle)
	
func _rotate_needle(is_right: bool):
	var dir = 1 if is_right else -1
	if Player.move_instant:
		needle.rotation += dir * (PI / 2)
	else:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(needle, "rotation", needle.rotation +  dir * (PI / 2), 0.15).finished
