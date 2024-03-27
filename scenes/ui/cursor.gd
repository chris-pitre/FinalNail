class_name Cursor
extends Control

@onready var tooltip_labels: Control  = $TooltipLabels
@onready var tooltip_right: Label = $TooltipLabels/LabelRight
@onready var tooltip_left: Label = $TooltipLabels/LabelLeft

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var glbl_mouse_pos = get_global_mouse_position()
		
		global_position = get_global_mouse_position()
		
		if get_global_mouse_position().x > 960:
			if not tooltip_left.visible:
				tooltip_left.show()
				tooltip_right.hide()
		else:
			if tooltip_left.visible:
				tooltip_left.hide()
				tooltip_right.show()

func show_tooltip(msg: String) -> void:
	tooltip_left.text = msg
	tooltip_right.text = msg
	tooltip_labels.show()

func hide_tooltip() -> void:
	tooltip_labels.hide()
