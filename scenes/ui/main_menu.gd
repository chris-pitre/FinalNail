extends Control

@onready var main_menu_buttons = $MainMenuButtons
@onready var credits_menu = $Credits

func _on_button_pressed() -> void:
	SignalBus.main_menu_clicked_play.emit()
	$"../UI".show()
	queue_free()


func _on_button_2_pressed() -> void:
	credits_menu.show()
	main_menu_buttons.hide()


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	credits_menu.hide()
	main_menu_buttons.show()
