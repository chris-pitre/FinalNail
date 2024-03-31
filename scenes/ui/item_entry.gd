extends MarginContainer

var item_name: String = ""
var item_id: String = ""

@onready var name_label: Label = $ItemEntryVBox/ItemInfo/ItemName
@onready var number_label: Label = $ItemEntryVBox/ItemInfo/ItemNumber
@onready var use_button: Button = $ItemEntryVBox/Button


func _ready() -> void:
	PlayerData.item_num_changed.connect(_player_item_num_changed)


func _player_item_num_changed(_item_id: String, amt_left: int) -> void:
	if item_id == _item_id:
		if amt_left == 0:
			use_button.disabled = true
		else:
			use_button.disabled = false
		number_label.text = str(amt_left)
		name_label.text = item_name


func _on_button_pressed() -> void:
	PlayerData.use_item(item_id)
