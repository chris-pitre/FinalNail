extends Node

const ITEMS_PATH = "res://src/items/"

var items: Array[Item] = []

func _ready() -> void:
	var directory: DirAccess = DirAccess.open(ITEMS_PATH)
	var item_paths: PackedStringArray = directory.get_files()
	for path in item_paths:
		var clipped_path = path.replace(".remap", "")
		if clipped_path.ends_with(".tres"):
			var item_resource = ResourceLoader.load(ITEMS_PATH + path)
			items.append(item_resource)
	for item in items:
		PlayerData.items[item.id] = 0


func get_item_data(id: int) -> Item:
	return items[id]
