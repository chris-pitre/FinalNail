class_name Map
extends Node3D

const GRASS_PATCH = preload("res://scenes/dressing/grass_patch.tscn")
const DIRT_DECAL = preload("res://scenes/dressing/dirt_decal.tscn")
const PEBBLE = preload("res://scenes/dressing/pebble.tscn")
const CELL = preload("res://scenes/cell/cell.tscn")

@export var map_scene: PackedScene
@export var cell_theme: CellTheme

var cells: Array[Cell]
static var map: TileMap
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	map_instance.hide()
	rng.seed = 13
	generate_level()

func generate_level():
	var used_cells = map.get_used_cells(0)
	var neighbors = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
	
	for tile in used_cells:
		var cell = CELL.instantiate()
		add_child(cell)
		cell.global_position = Vector3(tile.x * 2, 0, tile.y * 2)
		cells.append(cell)
		
		var tile_data = map.get_cell_tile_data(0, tile)
		var tile_open = tile_data.terrain == 1
		var corners = get_corners(tile_data)
		var neighbors_open = []
		for neighbor in neighbors:
			var neighbor_data = map.get_cell_tile_data(0, tile + neighbor)
			var neighbor_open
			if neighbor_data:
				neighbor_open = neighbor_data.terrain == 1
			else:
				neighbor_open = false
			neighbors_open.append(neighbor_open)
		
		#print(map.get_cell_atlas_coords(0, tile,))
		cell.set_faces(used_cells, tile_open, neighbors_open, corners, cell_theme)
		
		for i in range(rng.randi_range(0,32)):
			var pebble = PEBBLE.instantiate()
			cell.add_child(pebble)
			var rand_shift = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-0.04, 0.0), rng.randf_range(-1.0, 1.0))
			pebble.global_position = cell.global_position + rand_shift
			pebble.scale *= rng.randf_range(0.2, 1.5)
			pebble.rotate_x(rng.randf())
			pebble.rotate_y(rng.randf())
		
		if tile_open:
			for i in range(rng.randi_range(0, 16)):
				var grass = GRASS_PATCH.instantiate()
				cell.add_child(grass)
				var rand_shift = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-0.04, 0.0), rng.randf_range(-1.0, 1.0))
				grass.global_position = cell.global_position + rand_shift
				grass.scale *= rng.randf_range(0.2, 1.5)
				grass.rotate_x(rng.randf())
				grass.rotate_y(rng.randf())
		else:
			for i in range(rng.randi_range(0, 2)):
				var dirt = DIRT_DECAL.instantiate()
				cell.add_child(dirt)
				var rand_shift = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-0.04, 0.0), rng.randf_range(-1.0, 1.0))
				dirt.global_position = cell.global_position + rand_shift
				dirt.scale *= rng.randf_range(0.2, 1.5)
				dirt.rotate_x(rng.randf())
				dirt.rotate_y(rng.randf())
	
	var map_objects = map.get_children()
	
	for map_object in map_objects:
		var object = map_object.scene.instantiate()
		add_child(object)
		object.global_position = Vector3(map_object.position.x / 16.0 - 0.5, 0.0, map_object.position.y / 16.0 - 0.5) * 2
		object.rotate_y(-map_object.rotation)
		
		if map_object is DoorObject:
			object.listen_id = map_object.listen_id
		elif map_object is LeverObject:
			object.emit_id = map_object.emit_id
		elif map_object is NoteObject:
			object.text = map_object.text
		elif map_object is ItemObject:
			object.item_id = map_object.item_id
			object.amount = map_object.amount

func get_corners(tile_data: TileData) -> Dictionary:
	var corners: Dictionary = {}
	corners["SW"] = true if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) == -1 else false
	corners["SE"] = true if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) == -1 else false
	corners["NW"] = true if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) == -1 else false
	corners["NE"] = true if tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER) == -1 else false
	return corners
