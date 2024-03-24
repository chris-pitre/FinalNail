class_name Minimap
extends TileMap

@onready var cam := $MinimapCamera
@onready var marker := $MinimapCamera/PlayerMarker
@onready var new_pos: Vector2 = cam.position

func _ready():
	SignalBus.player_pos_updated.connect(_player_moved)
	SignalBus.player_dir_updated.connect(_player_rotated)
	_player_moved(0, 0)
	
func _player_moved(x, y):
	set_cells_terrain_connect(0, [Vector2i(x, y)], 0, 0)
	new_pos = Vector2(16 * x + 8, 16 * y + 8)
	if Player.move_instant:
		cam.position = new_pos

func _physics_process(delta):
	if not Player.move_instant:
		cam.position = cam.position.move_toward(new_pos, 100 * delta)

func _player_rotated(is_right):
	var angle = PI/2 if is_right else -PI/2
	marker.rotate(angle)

