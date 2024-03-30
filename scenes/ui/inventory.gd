extends Control

const ITEM_ENTRY = preload("res://scenes/ui/item_entry.tscn")

@onready var inventory_list: VBoxContainer = $ScrollContainer/InventoryList

func _ready() -> void:
	for item in ItemDatabase.items:
		var new_entry = ITEM_ENTRY.instantiate()
		inventory_list.add_child(new_entry)
		new_entry.item_id = item.id
		new_entry.get_node("ItemEntryVBox/ItemInfo/ItemName").text = item.name
		new_entry.get_node("ItemEntryVBox/ItemInfo/ItemName/TooltipperComponent").tooltip = item.description
		new_entry.get_node("ItemEntryVBox/ItemInfo/ItemNumber").text = str(0)
