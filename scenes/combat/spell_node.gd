class_name SpellNode
extends TextureButton

@onready var center := $Center
var is_active: bool = true

signal node_spell_drawn(center_pos)

func _on_mouse_entered():
	if is_active and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		node_spell_drawn.emit(center.global_position)
		is_active = false

func _input(event):
	if event.is_action_released("lmb"):
		is_active = true

func _on_button_down():
	if is_active:
		node_spell_drawn.emit(center.global_position)
		is_active = false
