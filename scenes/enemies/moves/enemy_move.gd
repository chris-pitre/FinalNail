class_name EnemyMove
extends Node3D

@export_range(0, 1, 0.01) var move_weight: float = 0.5
@export var move_describe: String

func execute():
	SignalBus.message_show.emit(move_describe, 2)
	await get_tree().create_timer(2).timeout
	for component in get_children():
		await component.execute()
	BattleManager.enemy_turn_end.emit()
