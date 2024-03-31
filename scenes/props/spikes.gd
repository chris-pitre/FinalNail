class_name Spikes
extends Node3D

func _on_area_3d_area_entered(area):
	if area.owner is Player:
		PlayerData.health -= 1
