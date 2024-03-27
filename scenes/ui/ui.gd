class_name UI
extends Control

static var current: UI

var options_open: bool = false

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
@onready var paper_scroll_menu = $PaperScrollMenu
@onready var cursor: Cursor = $Cursor


func _ready() -> void:
	current = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PlayerData.health_changed.connect(set_health)
	PlayerData.stat_changed.connect(set_stat)
	SignalBus.tooltip_show.connect(_show_tooltip)
	SignalBus.tooltip_hide.connect(_hide_tooltip)
	SignalBus.message_show.connect(display_message)


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


func open_options_menu() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(paper_scroll_menu, "size", Vector2(368, 1080), 0.3)


func close_options_menu() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(paper_scroll_menu, "size", Vector2(368, 0), 0.3)


func _on_message_timer_timeout() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(message, "modulate", Color.TRANSPARENT, 0.2)


func _on_options_button_pressed() -> void:
	if options_open:
		close_options_menu()
	else:
		open_options_menu()
	options_open = not options_open


func _show_tooltip(msg: String) -> void:
	cursor.show_tooltip(msg)


func _hide_tooltip() -> void:
	cursor.hide_tooltip()
