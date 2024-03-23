class_name Map
extends Node3D

const CELL = preload("res://scenes/cell/cell.tscn")

@export var map_scene: PackedScene
@export var cell_theme: CellTheme

var cells: Array[Cell]
var map: TileMap

func _ready():
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	map_instance.hide()
	generate_level()

func generate_level():
	var used_cells = map.get_used_cells(0)
	
	for tile in used_cells:
		var cell = CELL.instantiate()
		add_child(cell)
		cell.global_position = Vector3(tile.x * 2, 0, tile.y * 2)
		cells.append(cell)
		
		var tile_data = map.get_cell_tile_data(0, tile)
		var tile_open = tile_data.terrain == 1
		var corners = get_corners(tile_data)
		
		#print(map.get_cell_atlas_coords(0, tile,))
		cell.set_faces(used_cells, tile_open, corners, cell_theme)

func get_corners(tile_data: TileData) -> Dictionary:
	var corners: Dictionary
	corners["SW"] = false if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) == 1 else true
	corners["SE"] = false if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) == 1 else true
	corners["NW"] = false if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) == 1 else true
	corners["NE"] = false if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER) == 1 else true
	return corners
