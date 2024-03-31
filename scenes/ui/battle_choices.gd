extends Control

@onready var decree_button := preload("res://scenes/ui/decree_option.tscn")
@onready var exit_button := preload("res://scenes/ui/exit_button.tscn")
@onready var main_list := $MainChoices
@onready var decree_list := $DecreeChoices

func _ready():
	BattleManager.player_turn_start.connect(reset)

func reset():
	for child in decree_list.get_children():
		child.queue_free()
	SignalBus.hide_spell_cast.emit()
	main_list.visible = true
	decree_list.visible = false
	
func _on_attack_button_pressed():
	if BattleManager.current_turn == BattleManager.TURNS.PLAYER:
		var exit_button_instance = exit_button.instantiate()
		exit_button_instance.pressed.connect(_on_exit_button_pressed)
		decree_list.add_child(exit_button_instance)
		SignalBus.toggle_spell_cast.emit()
		main_list.visible = false
		decree_list.visible = true

func _on_decrees_button_pressed():
	if BattleManager.current_turn == BattleManager.TURNS.PLAYER:
		SignalBus.hide_spell_cast.emit()
		main_list.visible = false
		decree_list.visible = true
		for decree in PlayerData.decree_moves:
			var decree_button_instance = decree_button.instantiate()
			decree_button_instance.decree_func = PlayerData.decree_moves[decree][0]
			decree_button_instance.penalty = PlayerData.decree_moves[decree][1]
			decree_button_instance.text = decree
			decree_list.add_child(decree_button_instance)
		var exit_button_instance = exit_button.instantiate()
		exit_button_instance.pressed.connect(_on_exit_button_pressed)
		decree_list.add_child(exit_button_instance)

func _on_exit_button_pressed():
	reset()
