class_name Cursor
extends Control

@onready var tooltip_label: Label = $Label

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var glbl_mouse_pos = get_global_mouse_position()
		
		global_position = get_global_mouse_position()
		
		var hovering_tooltip: bool = false
		for tooltip_control: Control in get_tree().get_nodes_in_group("tooltip"):
			if tooltip_control.get_global_rect().has_point(glbl_mouse_pos):
				if tooltip_control.has_meta("tooltip"):
					hovering_tooltip = true
					tooltip_label.text = tooltip_control.get_meta("tooltip")
		
		tooltip_label.visible = hovering_tooltip
