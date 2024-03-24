class_name UI
extends Control

static var current: UI

@onready var stat_value_1 = $OuterMargin/ContentHBox/InfoVBox/StatsVBox/StatContainer/StatValue
@onready var stat_value_2 = $OuterMargin/ContentHBox/InfoVBox/StatsVBox/StatContainer2/StatValue
@onready var stat_value_3 = $OuterMargin/ContentHBox/InfoVBox/StatsVBox/StatContainer3/StatValue
@onready var stat_value_4 = $OuterMargin/ContentHBox/InfoVBox/StatsVBox/StatContainer4/StatValue
@onready var stat_value_5 = $OuterMargin/ContentHBox/InfoVBox/StatsVBox/StatContainer5/StatValue
@onready var health_bar = $OuterMargin/ContentHBox/ViewVBox/Healthbar
@onready var health_bar_label = $OuterMargin/ContentHBox/ViewVBox/Healthbar/Label
@onready var message = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/MessageGradient
@onready var message_label = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/MessageGradient/MessageLabel
@onready var message_timer = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/MessageGradient/MessageTimer
@onready var world_vp_container = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/WorldContainer


func _ready() -> void:
	current = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PlayerData.health_changed.connect(set_health)
	PlayerData.stat_changed.connect(set_stat)


func set_stat(stat: PlayerData.STAT, amount: int) -> void:
	match stat:
		PlayerData.STAT.COMPOSITION:
			stat_value_1.text = str(amount)
		PlayerData.STAT.SPIRIT:
			stat_value_2.text = str(amount)
		PlayerData.STAT.CORPUS:
			stat_value_3.text = str(amount)
		PlayerData.STAT.PREMONITION:
			stat_value_4.text = str(amount)
		PlayerData.STAT.PIETY:
			stat_value_5.text = str(amount)


func set_health(amount: int, max_amount: int) -> void:
	health_bar.max_value = max_amount
	health_bar.value = amount
	health_bar_label.text = "%d/%d" % [amount, max_amount]


func display_message(msg: String, time: float) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(message, "modulate", Color.WHITE, 0.2)
	message_timer.start(time)
	message_label.text = "[center]%s[/center]" % msg


func set_view_tooltip(tooltip: String) -> void:
	world_vp_container.set_meta("tooltip", tooltip)


func _on_message_timer_timeout() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(message, "modulate", Color.TRANSPARENT, 0.2)
