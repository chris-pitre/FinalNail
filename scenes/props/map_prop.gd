class_name PickableObject
extends Node3D

@export var tooltip: String = "This is a map object."

func _on_area_3d_mouse_entered() -> void:
	UI.current.set_view_tooltip(tooltip)

func _on_area_3d_mouse_exited() -> void:
	UI.current.set_view_tooltip("")
