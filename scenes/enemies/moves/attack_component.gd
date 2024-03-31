class_name AttackComponent
extends Node3D

@export var enemy: Enemy
@export var damage_type: BattleManager.DAMAGE
@export var attack_damage: int = 10
@export var active: bool = false

signal complete

func execute():
	if active:
		PlayerData.take_damage(damage_type, enemy.stats[1], attack_damage)
		await get_tree().create_timer(2).timeout
	return true
	
