class_name Map
extends Node3D

const CELL = preload("res://scenes/cell/cell.tscn")

@export var map_scene: PackedScene

var cells: Array[Cell]
var map: TileMap

func _ready():
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	generate_level()

func generate_level():
	var used_cells = map.get_used_cells(0)
	
	for tile in used_cells:
		var cell = CELL.instantiate()
		add_child(cell)
		cell.global_position = Vector3(tile.x * 2, 0, tile.y * 2)
		cells.append(cell)
	
	for cell in cells:
		cell.set_faces(used_cells)
