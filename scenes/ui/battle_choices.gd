extends Control

func _on_attack_button_pressed():
	if BattleManager.current_turn == BattleManager.TURNS.PLAYER:
		SignalBus.toggle_spell_cast.emit()

func _on_decrees_button_pressed():
	pass # Replace with function body.
