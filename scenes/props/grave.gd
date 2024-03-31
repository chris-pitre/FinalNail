extends Interactable

@onready var anim := $AnimationPlayer

func _ready() -> void:
	SignalBus.player_pos_updated.connect(_player_pos_updated)
	PlayerData.num_graves += 1

func interact() -> void:
	if PlayerData.souls > 0:
		PlayerData.use_soul()
		fade()

func fade() -> void:
	anim.play("fade")
	await anim.animation_finished
	queue_free()

