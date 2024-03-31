class_name CeilingAxe
extends Node3D

enum STATES {
	LM,
	MR,
	RM,
	ML
}

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision := $Area3D/CollisionShape3D

var currentState: STATES = STATES.LM
var counter: int = 0

func _ready():
	SignalBus.player_pos_updated.connect(_move_axe)

func _move_axe(x, y):
	if counter < 2:
		counter += 1
		return
	counter = 0
	match(currentState):
		STATES.LM:
			currentState = STATES.MR
			anim.play("leftmiddle")
			collision.disabled = false
			counter += 1
		STATES.MR:
			currentState = STATES.RM
			anim.play("middleright")
			collision.disabled = true
		STATES.RM:
			currentState = STATES.ML
			anim.play("rightmiddle")
			collision.disabled = false
			counter += 1
		STATES.ML:
			currentState = STATES.LM
			anim.play("middleleft")
			collision.disabled = true
			

func _on_area_3d_area_entered(area):
	if area.owner is Player:
		PlayerData.health -= 10
