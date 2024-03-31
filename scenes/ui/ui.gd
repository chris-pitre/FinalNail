class_name UI
extends Control

const HELM_PORTRAIT_HEALTHY = preload("res://assets/portraits/bellmet1.png")
const HELM_PORTRAIT_DAMAGED = preload("res://assets/portraits/bellmet2.png")
const HELM_PORTRAIT_VERY_DAMAGED = preload("res://assets/portraits/bellmet3.png")

static var current: UI

var journal_open: bool = false
var cur_page: int = 0
var scroll_open: bool = false
var scroll_opening: bool = false

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
@onready var fps_counter = $FPSCounter
@onready var world_vp_container = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/WorldContainer
@onready var paper_scroll_menu = $PaperScrollMenu
@onready var options_menu = $PaperScrollMenu/PaperBG/ScrollMenus/Options
@onready var inventory_menu = $PaperScrollMenu/PaperBG/ScrollMenus/Inventory
@onready var journal_menu = $OuterMargin/Journal
@onready var battle_choices_menu = $PaperScrollMenu/PaperBG/ScrollMenus/BattleChoices
@onready var cursor: Cursor = $"../Cursor"
@onready var portrait_texture = $OuterMargin/ContentHBox/InfoVBox/PortraitAspect/BorderExpand/Portrait
@onready var scroll_menus = $PaperScrollMenu/PaperBG/ScrollMenus
@onready var journal_info_label = $OuterMargin/Journal/VBoxContainer/JournalControls/JournalInfoLabel
@onready var journal_text = $OuterMargin/Journal/VBoxContainer/PaperTexture/PageMargin/JournalText
@onready var world = $OuterMargin/ContentHBox/ViewVBox/Viewport/BorderExpand/WorldContainer/WorldViewport/World
@onready var num_decrees = $OuterMargin/ContentHBox/ButtonsVBox/DecreeCross/DecreeNum
@onready var level_up_menu = $PaperScrollMenu/PaperBG/ScrollMenus/LevelUp
@onready var num_souls = $OuterMargin/ContentHBox/ButtonsVBox/Souls/SoulNum
@onready var death_screen = $DeathScreen
@onready var death_return = $DeathScreen/MarginContainer/DeathReturn

func _ready() -> void:
	current = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	paper_scroll_menu.size = Vector2(368, 0)
	PlayerData.health_changed.connect(set_health)
	PlayerData.stat_changed.connect(set_stat)
	PlayerData.decrees_changed.connect(set_decrees)
	PlayerData.player_died.connect(_player_died)
	PlayerData.added_note.connect(_added_note)
	PlayerData.souls_changed.connect(set_souls)
	SignalBus.tooltip_show.connect(_show_tooltip)
	SignalBus.tooltip_hide.connect(_hide_tooltip)
	SignalBus.message_show.connect(display_message)
	BattleManager.player_turn_start.connect(_show_battle_menu)
	BattleManager.hide_scroll.connect(close_scroll)
	SignalBus.player_stats_updated.connect(update_stats)
	SignalBus.main_menu_clicked_play.connect(_started_game)
	SignalBus.won.connect(_won_game)
	SignalBus.toggle_level_up.connect(_show_level_up_screen)
	SignalBus.hide_level_up.connect(close_scroll)
	update_stats()


func _process(delta: float) -> void:
	fps_counter.text = "FPS: %d" % Engine.get_frames_per_second()

func set_decrees(amount: int) -> void:
	num_decrees.text = str(amount)

func set_souls(amount: int) -> void:
	num_souls.text = str(amount)

func update_stats() -> void:
	var stats = PlayerData.stats
	set_stat(PlayerData.STAT.COMPOSITION, stats[0])
	set_stat(PlayerData.STAT.SPIRIT, stats[1])
	set_stat(PlayerData.STAT.CORPUS, stats[2])
	set_stat(PlayerData.STAT.PREMONITION, stats[3])
	set_stat(PlayerData.STAT.PIETY, stats[4])

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
	if amount < max_amount * 0.33:
		portrait_texture.texture = HELM_PORTRAIT_VERY_DAMAGED
	elif amount < max_amount * 0.67:
		portrait_texture.texture = HELM_PORTRAIT_DAMAGED
	else:
		portrait_texture.texture = HELM_PORTRAIT_HEALTHY


func display_message(msg: String, time: float, silent: bool = false) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(message, "modulate", Color.WHITE, 0.2)
	message_timer.start(time)
	message_label.text = "[center]%s[/center]" % msg
	if not silent:
		Audio.play_sound("res://assets/sfx/ding.ogg", "SFX")


func set_view_tooltip(tooltip: String) -> void:
	world_vp_container.set_meta("tooltip", tooltip)


func toggle_scroll(menu: Control) -> void:
	if scroll_open:
		if menu.visible:
			if BattleManager.battle_active:
				open_scroll(battle_choices_menu)
			else:
				close_scroll()
		else:
			await close_scroll()
			open_scroll(menu)
	else:
		open_scroll(menu)


func open_scroll(menu: Control) -> void:
	if scroll_opening:
		return
	
	scroll_open = true
	for scroll_menu in scroll_menus.get_children():
		scroll_menu.hide()
	menu.visible = true
	scroll_opening = true
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(paper_scroll_menu, "size", Vector2(368, 1080), 0.3).finished
	scroll_opening = false


func close_scroll() -> void:
	if scroll_opening:
		return
	
	scroll_opening = true
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(paper_scroll_menu, "size", Vector2(368, 0), 0.3).finished
	scroll_opening = false
	scroll_open = false


func update_journal_text() -> void:
	journal_text.text = PlayerData.found_notes[cur_page]
	journal_info_label.text = "%d/%d" % [cur_page + 1, PlayerData.found_notes.size()]


func _started_game() -> void:
	world.show()


func _on_message_timer_timeout() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(message, "modulate", Color.TRANSPARENT, 0.2)


func _on_options_button_pressed() -> void:
	toggle_scroll(options_menu)


func _on_inventory_button_pressed() -> void:
	toggle_scroll(inventory_menu)


func _on_journal_button_pressed() -> void:
	journal_open = not journal_open
	journal_menu.visible = journal_open
	if PlayerData.found_notes.size() > 0:
		update_journal_text() 
	else:
		journal_text.text = ""


func _show_tooltip(msg: String) -> void:
	cursor.show_tooltip(msg)


func _hide_tooltip() -> void:
	cursor.hide_tooltip()


func _on_spin_box_value_changed(value: float) -> void:
	Player.input_queue_size = int(value)


func _on_master_slider_value_changed(value: float) -> void:
	var bus_idx = 0
	var final_db = (value - 50.0) / 2.0
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_volume_db(bus_idx, final_db)


func _on_sfx_slider_value_changed(value: float) -> void:
	var bus_idx = 1
	var final_db = (value - 50.0) / 2.0
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_volume_db(bus_idx, final_db)


func _on_ambience_slider_value_changed(value: float) -> void:
	var bus_idx = 2
	var final_db = (value - 50.0) / 2.0
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_volume_db(bus_idx, final_db)


func _on_instant_movement_check_box_toggled(toggled_on: bool) -> void:
	Player.move_instant = toggled_on


func _on_fps_check_box_toggled(toggled_on: bool) -> void:
	fps_counter.visible = toggled_on


func _on_left_button_pressed() -> void:
	cur_page -= 1
	cur_page = wrapi(cur_page, 0, PlayerData.found_notes.size())
	if PlayerData.found_notes.size() > 0:
		update_journal_text() 


func _on_right_button_pressed() -> void:
	cur_page += 1
	cur_page = wrapi(cur_page, 0, PlayerData.found_notes.size())
	if PlayerData.found_notes.size() > 0:
		update_journal_text() 


func _added_note() -> void:
	cur_page = PlayerData.found_notes.size() - 1
	journal_info_label.text = "%d/%d" % [cur_page + 1, PlayerData.found_notes.size()]
	

func _show_battle_menu() -> void:
	toggle_scroll(battle_choices_menu)
	
func _show_level_up_screen() -> void:
	toggle_scroll(level_up_menu)


func _won_game() -> void:
	pass

func _on_death_return_pressed() -> void:
	death_return.hide()
	SignalBus.player_returned.emit()
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(death_screen, "modulate:a", 0.0, 0.5).finished
	death_screen.hide()

func _player_died() -> void:
	death_screen.show()
	death_screen.modulate.a = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(death_screen, "modulate:a", 1.0, 0.5).finished
	death_return.show()
