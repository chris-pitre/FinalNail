extends MarginContainer

var item: Item

@onready var name_label: Label = $ItemEntryVBox/ItemInfo/ItemName
@onready var button: Button = $ItemEntryVBox/ItemInfo/UseButton
@onready var tooltipper: TooltipperComponent = $ItemEntryVBox/ItemInfo/ItemName/TooltipperComponent

func _ready() -> void:
	PlayerData.item_num_changed.connect(_player_item_num_changed)


func _player_item_num_changed(_item_id: String, amt_left: int) -> void:
	if item.id == _item_id:
		if amt_left == 0:
			button.disabled = true
		else:
			button.disabled = false
		button.text = str(amt_left)
		name_label.text = item.name
		tooltipper.tooltip = item.description


func _on_button_pressed() -> void:
	PlayerData.use_item(item.id)
