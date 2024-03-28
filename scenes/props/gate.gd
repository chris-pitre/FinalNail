extends Node3D

@onready var gate_anim := $AnimationPlayer
@onready var collision := $Area3D/CollisionShape3D

var is_open: bool = false

func _open():
	gate_anim.play("open")
	await gate_anim.animation_finished
	is_open = true
	collision.disabled = true

func _close():
	gate_anim.play("close")
	await gate_anim.animation_finished
	is_open = false
	collision.disabled = false
