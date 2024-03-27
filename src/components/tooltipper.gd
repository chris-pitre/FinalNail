class_name TooltipperComponent
extends Node

@export_multiline var tooltip: String = "default tooltip"

func _ready() -> void:
	if get_parent() is Control:
		get_parent().mouse_entered.connect(_mouse_entered)
		get_parent().mouse_exited.connect(_mouse_exited)


func _mouse_entered() -> void:
	SignalBus.tooltip_show.emit(tooltip)


func _mouse_exited() -> void:
	SignalBus.tooltip_hide.emit()
