class_name LevelUp
extends Control

var is_active: bool = false

func _ready():
	SignalBus.toggle_level_up.connect(level_up_ready)

func level_up(stat: PlayerData.STAT):
	if PlayerData.decrees > 0:
		PlayerData.change_decrees(-1)
		PlayerData.change_stat(stat, 1)
		SignalBus.message_show.emit("You feel new power enter your body", 1, true)
		Audio.play_sound("res://assets/sfx/click2.ogg", "SFX", 0.0, 1.0)
	else:
		SignalBus.message_show.emit("You lack divine favor with your patron!", 1, true)
		Audio.play_sound("res://assets/sfx/ding.ogg", "SFX", 0.0, 0.2)

func _input(event):
	if is_active and event.is_pressed():
		if event.is_action("move_forward"):
			level_up_deactivate()
		if event.is_action("move_backward"):
			level_up_deactivate()
		if event.is_action("move_left"):
			level_up_deactivate()
		if event.is_action("move_right"):
			level_up_deactivate()
		if event.is_action("rotate_left"):
			level_up_deactivate()
		if event.is_action("rotate_right"):
			level_up_deactivate()

func level_up_ready():
	is_active = true

func level_up_deactivate():
	is_active = false
	SignalBus.hide_level_up.emit()

func _on_composition_button_pressed():
	level_up(PlayerData.STAT.COMPOSITION)


func _on_spirit_button_pressed():
	level_up(PlayerData.STAT.SPIRIT)


func _on_corpus_button_pressed():
	level_up(PlayerData.STAT.CORPUS)


func _on_premonition_button_pressed():
	level_up(PlayerData.STAT.PREMONITION)


func _on_exit_button_pressed():
	level_up_deactivate()
