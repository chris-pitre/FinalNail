extends Button

var decree_func: Callable
var penalty: int

func _on_pressed():
	if BattleManager.current_turn == BattleManager.TURNS.PLAYER:
		disabled = true
		SignalBus.message_show.emit("Lacking somatic coalescence, your spell weakens...", 2, true)
		Audio.play_sound("res://assets/sfx/ding.ogg", "SFX", 0.0, 0.2)
		await get_tree().create_timer(1.0).timeout
		decree_func.call(penalty)
