extends Node

signal rotate_player(is_right)
signal player_pos_updated(x, y)
signal player_dir_updated(is_right)
signal player_check_enemy()
signal player_stats_updated()

signal message_show(msg: String, time: float)
signal tooltip_show(msg: String)
signal tooltip_hide()
signal main_menu_clicked_play()

signal switch_flipped(id: int)

signal toggle_spell_cast()
signal hide_spell_cast()
