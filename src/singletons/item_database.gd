extends Node

const ITEMS_PATH = "res://src/items/"

var items: Array[Item] = []

func _ready() -> void:
	var directory: DirAccess = DirAccess.open(ITEMS_PATH)
	var item_paths: PackedStringArray = directory.get_files()
	for path in item_paths:
		if path.ends_with(".remap") or path.ends_with(".tres"):
			var item_resource = ResourceLoader.load(ITEMS_PATH + path)
			items.append(item_resource)


func get_item_data(id: int) -> Item:
	return items[id]
