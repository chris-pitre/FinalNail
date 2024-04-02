class_name Cell
extends Node3D

#faces
@onready var top := $TopFace
@onready var bottom := $BottomFace
@onready var east := $EastFace
@onready var west := $WestFace
@onready var north := $NorthFace
@onready var south := $SouthFace

#uppertrim
@onready var east_wall := $UpperTrim/EastWall
@onready var west_wall := $UpperTrim/WestWall
@onready var north_wall := $UpperTrim/NorthWall
@onready var south_wall := $UpperTrim/SouthWall

#corners
@onready var pillars := $Pillars
@onready var se_pillar := $Pillars/SouthEastPillar
@onready var sw_pillar := $Pillars/SouthWestPillar
@onready var nw_pillar := $Pillars/NorthWestPillar
@onready var ne_pillar := $Pillars/NorthEastPillar

func _ready() -> void:
	SignalBus.player_pos_updated.connect(_player_pos_updated)

func set_faces(cell_list: Array[Vector2i], tile_open: bool, neighbors_open: Array, corners: Dictionary, cell_theme: CellTheme) -> void:
	bottom.material_override = cell_theme.floor_out if tile_open else cell_theme.floor_tex
	east.material_override = cell_theme.wall
	west.material_override = cell_theme.wall
	north.material_override = cell_theme.wall
	south.material_override = cell_theme.wall
	top.material_override = cell_theme.ceiling
	
	var grid_pos = Vector2i(round(global_position.x) / 2, round(global_position.z) / 2)
	
	if cell_list.has(grid_pos + Vector2i.RIGHT):
		east.hide()
	if cell_list.has(grid_pos + Vector2i.LEFT):
		west.hide()
	if cell_list.has(grid_pos + Vector2i.DOWN):
		south.hide()
	if cell_list.has(grid_pos + Vector2i.UP):
		north.hide()
	if tile_open:
		top.hide()
	
	if tile_open:
		if neighbors_open[0]:
			east_wall.hide()
		if neighbors_open[1]:
			south_wall.hide()
		if neighbors_open[2]:
			west_wall.hide()
		if neighbors_open[3]:
			north_wall.hide()
	else:
		east_wall.hide()
		south_wall.hide()
		west_wall.hide()
		north_wall.hide()
	
	if cell_theme.pillars:
		pillars.visible = true
		if corners["SE"]:
			se_pillar.visible = true
		if corners["SW"]:
			sw_pillar.visible = true
		if corners["NW"]:
			nw_pillar.visible = true
		if corners["NE"]:
			ne_pillar.visible = true

func _player_pos_updated(x: int, y: int) -> void:
	var player_global_pos = Vector3((x + 0.5) * 2, 1.0, (y + 0.5) * 2)
	if (global_position - player_global_pos).length() > 20.0:
		hide()
	else:
		show()
