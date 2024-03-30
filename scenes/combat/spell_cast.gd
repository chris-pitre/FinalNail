class_name SpellCast
extends Control

@onready var spell_line := $SpellLine

var point_queue: Array = []
var attack_id: int = 0

func _ready():
	for spell_node in $SpellNodes.get_children():
		spell_node.node_spell_drawn.connect(_draw_spell)
	
func _input(event):
	if event.is_action_released("lmb"):
		PlayerData.validate_attack(attack_id)
		for point in spell_line.get_point_count():
			if spell_line.get_point_count() > 1:
				var tween = get_tree().create_tween()
				await tween.tween_method(tween_line.bind(0), spell_line.points[0], spell_line.points[1], 0.05).finished
				spell_line.remove_point(0)
			else:
				spell_line.clear_points()
		attack_id = 0
	
	if event.is_action_pressed("lmb"):
		spell_line.clear_points()
		attack_id = 0

func _process(delta):
	if not point_queue.is_empty():
		var point_idx = spell_line.get_point_count() - 1
		var next_point = point_queue.pop_front()		
		var original_point = spell_line.points[point_idx]
		
		spell_line.add_point(original_point, spell_line.get_point_count())
		var tween = get_tree().create_tween()
		await tween.tween_method(tween_line.bind(point_idx + 1), original_point, next_point, 0.25).finished
		
func tween_line(point_pos, point_idx):
	spell_line.set_point_position(point_idx, point_pos)

func _draw_spell(center_pos, id):
	attack_id += id
	var num_points = spell_line.get_point_count()
	if num_points <= 0:
		spell_line.add_point(spell_line.to_local(center_pos), num_points)
	else:
		point_queue.push_back(spell_line.to_local(center_pos))

func _show_nodes():
	visible = true
