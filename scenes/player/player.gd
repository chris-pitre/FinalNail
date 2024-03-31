class_name Player
extends Node3D

const STEPS_PATH = "res://assets/sfx/footsteps/"

enum DIRECTION {
	FORWARD,
	RIGHT,
	BACKWARD,
	LEFT,
}

var frozen: bool = true
var moving: bool = false
var input_queue: Array = []
var last_input: Callable
var footstep_sounds: Dictionary = {}

@onready var move_raycast: RayCast3D = $MoveRaycast
@onready var check_raycast: RayCast3D = $Camera3D/CheckRaycast
@onready var anim: AnimationPlayer = $Viewmodel/shove/AnimationPlayer
@onready var coffin := $coff
@onready var coffin_anim: AnimationPlayer = $coff/AnimationPlayer

static var move_instant: bool = false
static var input_queue_size: int = 2

func _ready():
	BattleManager.battle_start.connect(clear_queue)
	PlayerData.animation_played.connect(play_animation)
	PlayerData.coffin_attack.connect(coffin_kill)
	SignalBus.rotate_player.connect(do_rotate)
	SignalBus.player_check_enemy.connect(check_enemy)
	SignalBus.main_menu_clicked_play.connect(_started_game)
	anim.play("idle")
	get_footstep_sounds()

func _process(_delta):
	if not input_queue.is_empty() and not moving:
		var command = input_queue.pop_front()
		if input_queue.size() > 0 and not Input.is_action_pressed(command[2]) and input_queue.front() == command:
			input_queue.clear()
		else:
			play_footstep()
			command[0].call(command[1])

func _input(event):
	if not frozen:
		if BattleManager.battle_active:
			return
		if event.is_pressed() and (move_instant or input_queue.size() <= input_queue_size):
			if event.is_action("move_forward"):
				input_queue.push_back([Callable(do_movement), DIRECTION.FORWARD, "move_forward"]) 
			if event.is_action("move_backward"):
				input_queue.push_back([Callable(do_movement), DIRECTION.BACKWARD, "move_backward"]) 
			if event.is_action("move_left"):
				input_queue.push_back([Callable(do_movement), DIRECTION.LEFT, "move_left"]) 
			if event.is_action("move_right"):
				input_queue.push_back([Callable(do_movement), DIRECTION.RIGHT, "move_right"]) 
			if event.is_action("rotate_left"):
				input_queue.push_back([Callable(do_rotate), false, "rotate_left"]) 
			if event.is_action("rotate_right"):
				input_queue.push_back([Callable(do_rotate), true, "rotate_right"])
			if event.is_action("wait"):
				SignalBus.player_pos_updated.emit(global_position.x / 2, global_position.z / 2)

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
	
	check_enemy()
	
	slide(vec_dir, success)

func do_rotate(is_right: bool):
	var dir = 1 if is_right else -1
	moving = true
	if move_instant:
		rotation -= Vector3(0, dir * (PI / 2), 0)
	else:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		await tween.tween_property(self, "rotation", rotation - Vector3(0, dir * (PI / 2), 0), 0.15).finished
		
	check_enemy()
		
	PlayerData.facing = to_global(check_raycast.target_position)
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

func clear_queue():
	input_queue.clear()

func get_footstep_sounds() -> void:
	var directory: DirAccess = DirAccess.open(STEPS_PATH)
	var sound_folders: PackedStringArray = directory.get_directories()
	for folder in sound_folders:
		footstep_sounds[folder.get_basename()] = []
		var sound_folder = DirAccess.open(STEPS_PATH + folder)
		var sounds = sound_folder.get_files()
		for sound in sounds:
			var clipped_path = sound.replace(".import", "")
			if clipped_path.ends_with(".wav"):
				footstep_sounds[folder.get_basename()].append(STEPS_PATH + folder + "/" + clipped_path)

func play_footstep():
	var cell_pos = (Vector2(global_position.x, global_position.z) / 2).floor()
	var terrain = Map.map.get_cell_tile_data(0, cell_pos).terrain
	var sounds: Array
	match terrain:
		0:
			sounds = footstep_sounds["stone"]
		1:
			sounds = footstep_sounds["grass"]
	var rand_step = randi() % sounds.size()
	Audio.play_sound(sounds[rand_step], "SFX", 0.1)

func check_enemy():
	if check_raycast.is_colliding():
		var collision = check_raycast.get_collider()
		if collision.owner is Enemy:
			PlayerData.enemy_sighted = true
		else:
			PlayerData.enemy_sighted = false

func play_animation(anim_name: String) -> void:
	anim.play(anim_name)
	await anim.animation_finished
	anim.play("idle")

func coffin_kill() -> void:
	coffin.position = Vector3(0.0, -10.25, -2.0)
	coffin.visible = true
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(coffin, "position:y", coffin.position.y + 10, 1).finished
	coffin_anim.play("open")
	await coffin_anim.animation_finished
	var tween2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween2.tween_property(coffin, "position:z", coffin.position.z + 1, 0.2).finished
	coffin_anim.play("close")
	BattleManager.hide_enemy.emit()
	await coffin_anim.animation_finished
	var tween3 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween3.tween_property(coffin, "position:y", coffin.position.y - 10, 1).finished

func _started_game() -> void:
	frozen = false
