class_name CellTheme
extends Resource

@export var floor: StandardMaterial3D
@export var wall: StandardMaterial3D
@export var ceiling: StandardMaterial3D

func _init(p_floor = null, p_wall = null, p_ceiling = null):
	floor = p_floor
	wall = p_wall
	ceiling = p_ceiling
