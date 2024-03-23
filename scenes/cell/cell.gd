class_name Cell
extends Node3D

@onready var top := $TopFace
@onready var bottom := $BottomFace
@onready var east := $EastFace
@onready var west := $WestFace
@onready var north := $NorthFace
@onready var south := $SouthFace

func set_faces(cell_list: Array[Vector2i]) -> void:
	var grid_pos = Vector2i(global_position.x / 2, global_position.z / 2)
	if cell_list.has(grid_pos + Vector2i.RIGHT):
		east.hide()
	if cell_list.has(grid_pos + Vector2i.LEFT):
		west.hide()
	if cell_list.has(grid_pos + Vector2i.DOWN):
		south.hide()
	if cell_list.has(grid_pos + Vector2i.UP):
		north.hide()
