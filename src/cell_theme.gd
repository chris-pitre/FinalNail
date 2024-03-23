class_name CellTheme
extends Resource

@export var floor_tex: StandardMaterial3D
@export var wall: StandardMaterial3D
@export var ceiling: StandardMaterial3D
@export var pillars: bool

func _init(p_floor_tex = null, p_wall = null, p_ceiling = null, p_pillars = true):
	floor_tex = p_floor_tex
	wall = p_wall
	ceiling = p_ceiling
	pillars = p_pillars
