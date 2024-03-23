class_name Player
extends Node3D

enum DIRECTION {
	FORWARD,
	RIGHT,
	BACKWARD,
	LEFT,
}

var facing: DIRECTION = DIRECTION.FORWARD
var moving: bool = false

@onready var move_raycast: RayCast3D = $MoveRaycast

func _process(delta):
	print(move_raycast.is_colliding())

func _input(event):
	if event.is_pressed() and not moving:
		if event.is_action("move_forward"):
			do_movement(DIRECTION.FORWARD)
		if event.is_action("move_backward"):
			do_movement(DIRECTION.BACKWARD)
		if event.is_action("move_left"):
			do_movement(DIRECTION.LEFT)
		if event.is_action("move_right"):
			do_movement(DIRECTION.RIGHT)
		if event.is_action("rotate_left"):
			do_rotate(false)
		if event.is_action("rotate_right"):
			do_rotate(true)
					
func do_movement(dir: DIRECTION):
	var vec_dir = -basis.z
	vec_dir = vec_dir.rotated(Vector3.DOWN, (PI / 2) * dir) * 2
	
	move_raycast.target_position = to_local(global_position + vec_dir)
	move_raycast.force_raycast_update()
	
	var success := false
	
	if move_raycast.is_colliding():
		var collision = move_raycast.get_collider()
		if collision.owner is Cell:
			success = true
	
	slide(vec_dir, success)

func do_rotate(is_right: bool):
	var dir = 1 if is_right else -1
	moving = true
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	await tween.tween_property(self, "rotation", rotation - Vector3(0, dir * (PI / 2), 0), 0.15).finished
	moving = false
  

func slide(dir: Vector3, success: bool):
	moving = true
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	if not success:
		dir /= 4
	
	await tween.tween_property(self, "global_position", global_position + dir, 0.15).finished
	
	if not success:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(self, "global_position", global_position - dir, 0.15).finished
	
	moving = false
		
