extends Control

const ITEM_ENTRY = preload("res://scenes/ui/item_entry.tscn")

@onready var inventory_list: VBoxContainer = $ScrollContainer/InventoryList

func _ready() -> void:
	for item in ItemDatabase.items:
		var new_entry = ITEM_ENTRY.instantiate()
		inventory_list.add_child(new_entry)
		new_entry.item = item
		new_entry.name_label.text = "???"
		new_entry.button.text = "0"
		new_entry.button.disabled = true
