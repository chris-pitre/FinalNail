extends Node3D

@onready var gate_anim := $AnimationPlayer
@onready var collision := $Area3D/CollisionShape3D

var is_open: bool = false

var listen_id: int = -1

func _ready():
	SignalBus.switch_flipped.connect(_toggle)

func _open():
	gate_anim.play("open")
	collision.disabled = true
	await gate_anim.animation_finished
	is_open = true

func _close():
	gate_anim.play("close")
	collision.disabled = false
	await gate_anim.animation_finished
	is_open = false

func _toggle(emit_id):
	if emit_id != listen_id:
		return
		
	if is_open:
		_close()
	else:
		_open()
