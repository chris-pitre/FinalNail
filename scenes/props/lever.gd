extends Node3D

@onready var lever_anim := $AnimationPlayer
@onready var sound = $Sound

var is_left: bool = false
var moving: bool = false

var emit_id: int = -1

func _toggle():
	SignalBus.switch_flipped.emit(emit_id)
	sound.play()
	if is_left:
		moving = true
		lever_anim.play("Anim2")
		await lever_anim.animation_finished
		moving = false
		is_left = not is_left
	else:
		moving = true
		lever_anim.play("Anim1")
		await lever_anim.animation_finished
		moving = false
		is_left = not is_left

func _on_area_3d_input_event(camera, event, pos, normal, shape_idx):
	if event.is_action_pressed("lmb") and not moving:
		_toggle()
