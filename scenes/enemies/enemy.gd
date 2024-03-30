class_name Enemy
extends Node3D

enum STAT {
	COMPOSITION,
	SPIRIT,
	CORPUS,
	PREMONITION,
	PIETY,
}

@onready var movecasts := $MoveRaycasts
@export var enemy_name: String = "Dummy"
@export var max_hp: int = 20
var hp: int
# Composition, Spirit, Corpus, Premonition, Piety
@export var stats: Array[int] = [5, 5, 5, 5, 5]
@export_flags("Blunt:1", "Slashing:2", "Piercing:4", "Magic:8") var resists = 0

func _ready():
	SignalBus.player_pos_updated.connect(_check_for_player)
	BattleManager.enemy_turn_start.connect(do_turn)
	hp = max_hp
	
func _check_for_player(x, y):
	for raycast in movecasts.get_children():
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.owner is Player:
				BattleManager.start_battle(self)
				SignalBus.player_check_enemy.emit()
				while(not PlayerData.enemy_sighted):
					var dot_product = to_global(raycast.target_position).dot(PlayerData.facing)
					if dot_product >= 1 or dot_product <= -1:
						SignalBus.rotate_player.emit(true)
					else:
						SignalBus.rotate_player.emit(dot_product > 0)
					await SignalBus.player_dir_updated

func take_damage(damage: int, spirit: int, skill_damage: int):
	var dmg_effectiveness = pow(1.05, (spirit - stats[2]))
	var resist = 0.5 if (damage & resists) == 1 else 1.0
	var actual_dmg = floor(dmg_effectiveness * skill_damage * resist) + 1
	hp -= actual_dmg
	if resist == 0.5:
		SignalBus.message_show.emit("%s resisted some of the attack" % [enemy_name], 1)
	else: 
		SignalBus.message_show.emit("%s took the full brunt of the attack" % [enemy_name], 1)
	await get_tree().create_timer(1).timeout
	SignalBus.message_show.emit("%s received %d damage" % [enemy_name, actual_dmg], 2, true)
	await get_tree().create_timer(2).timeout
	if hp <= 0:
		SignalBus.message_show.emit("%s has been slain" % [enemy_name], 2, true)
		BattleManager.end_battle(true)
		queue_free()
	else:
		BattleManager.player_turn_end.emit()
	

func do_turn():
	PlayerData.take_damage(BattleManager.DAMAGE.BLUNT, stats[1], 10)
