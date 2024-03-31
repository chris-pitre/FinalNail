extends Control


func _on_button_pressed() -> void:
	SignalBus.main_menu_clicked_play.emit()
	$"../UI".show()
	queue_free()
