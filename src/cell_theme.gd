class_name CellTheme
extends Resource

@export var floor_tex: StandardMaterial3D
@export var wall: StandardMaterial3D
@export var ceiling: StandardMaterial3D

func _init(p_floor_tex = null, p_wall = null, p_ceiling = null):
	floor_tex = p_floor_tex
	wall = p_wall
	ceiling = p_ceiling
