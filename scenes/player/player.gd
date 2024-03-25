class_name Player
extends Node3D

enum DIRECTION {
	FORWARD,
	RIGHT,
	BACKWARD,
	LEFT,
}

var moving: bool = false
var input_queue: Array = []

@onready var move_raycast: RayCast3D = $MoveRaycast

static var move_instant: bool = false

func _process(delta):
	if not input_queue.is_empty() and not moving:
		var command = input_queue.pop_front()
		command[0].call(command[1])

func _input(event):
	if event.is_pressed() and (move_instant or input_queue.size() <= 2):
		if event.is_action("move_forward"):
			input_queue.push_back([Callable(do_movement), DIRECTION.FORWARD]) 
		if event.is_action("move_backward"):
			input_queue.push_back([Callable(do_movement), DIRECTION.BACKWARD]) 
		if event.is_action("move_left"):
			input_queue.push_back([Callable(do_movement), DIRECTION.LEFT]) 
		if event.is_action("move_right"):
			input_queue.push_back([Callable(do_movement), DIRECTION.RIGHT]) 
		if event.is_action("rotate_left"):
			input_queue.push_back([Callable(do_rotate), false]) 
		if event.is_action("rotate_right"):
			input_queue.push_back([Callable(do_rotate), true]) 
	if event.is_released():
		if event.is_action("move_forward"):
			input_queue.erase([Callable(do_movement), DIRECTION.FORWARD]) 
		if event.is_action("move_backward"):
			input_queue.erase([Callable(do_movement), DIRECTION.BACKWARD]) 
		if event.is_action("move_left"):
			input_queue.erase([Callable(do_movement), DIRECTION.LEFT]) 
		if event.is_action("move_right"):
			input_queue.erase([Callable(do_movement), DIRECTION.RIGHT]) 
		if event.is_action("rotate_left"):
			input_queue.erase([Callable(do_rotate), false]) 
		if event.is_action("rotate_right"):
			input_queue.erase([Callable(do_rotate), true])
					
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
	if move_instant:
		rotation -= Vector3(0, dir * (PI / 2), 0)
	else:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(self, "rotation", rotation - Vector3(0, dir * (PI / 2), 0), 0.15).finished
	
	SignalBus.player_dir_updated.emit(is_right)
	
	moving = false
  

func slide(dir: Vector3, success: bool):
	moving = true		
	if not success:
		input_queue.clear()
		dir /= 4
		
	if move_instant and success:
		global_position += dir
	elif not move_instant:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(self, "global_position", global_position + dir, 0.15).finished
		if not success:
			tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			await tween.tween_property(self, "global_position", global_position - dir, 0.15).finished
		
	global_position = Vector3(round(global_position.x), round(global_position.y), round(global_position.z))
	SignalBus.player_pos_updated.emit(global_position.x / 2, global_position.z / 2)
	
	moving = false
