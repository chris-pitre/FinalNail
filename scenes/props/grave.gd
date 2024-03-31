extends Node3D

@onready var anim := $AnimationPlayer

func _ready() -> void:
	PlayerData.num_graves += 1

func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("lmb"):
		if PlayerData.souls > 0:
			PlayerData.use_soul()
			fade()

func fade() -> void:
	anim.play("fade")
	await anim.animation_finished
	queue_free()
