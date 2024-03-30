extends MarginContainer

var item_id: String = ""

@onready var item_number: Label = $ItemEntryVBox/ItemInfo/ItemNumber
@onready var use_button: Button = $ItemEntryVBox/Button


func _ready() -> void:
	PlayerData.item_used.connect(_player_used_item)


func _player_used_item(_item_id: String, amt_left: int) -> void:
	if item_id == _item_id:
		if amt_left == 0:
			use_button.disabled = true
		else:
			use_button.disabled = false
		item_number.text = str(amt_left)


func _on_button_pressed() -> void:
	PlayerData.use_item(item_id)
