class_name Cursor
extends Control

@onready var tooltip_panel: PanelContainer = $PanelContainer
@onready var tooltip_label: Label = $PanelContainer/MarginContainer/Label

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = event.global_position
		
		if event.global_position.x > get_viewport().get_size().x - 240:
			tooltip_panel.set_end(Vector2(get_viewport().get_size().x, tooltip_panel.get_end().y) - global_position)
		else:
			tooltip_panel.size.x = 240
		
		var hovering_tooltip: bool = false
		for tooltip_control: Control in get_tree().get_nodes_in_group("tooltip"):
			if tooltip_control.get_global_rect().has_point(event.global_position):
				hovering_tooltip = true
				if tooltip_control.has_meta("tooltip"):
					tooltip_label.text = tooltip_control.get_meta("tooltip")
		
		tooltip_panel.visible = hovering_tooltip
