extends Node

func play_sound(path: String, bus: StringName, rand_pitch: float = 0.1) -> void:
	var new_sound = AudioStreamPlayer.new()
	add_child(new_sound)
	new_sound.bus = bus
	new_sound.stream = load(path)
	new_sound.pitch_scale += randf_range(-rand_pitch, rand_pitch)
	new_sound.pitch_scale = clampf(new_sound.pitch_scale, 0.02, 10.0)
	new_sound.play()
	await new_sound.finished
	new_sound.queue_free()
