extends Node

signal player_pos_updated(x, y)
signal player_dir_updated(is_right)

signal message_show(msg: String, time: float)
signal tooltip_show(msg: String)
signal tooltip_hide()

signal switch_flipped(id: int)

signal player_turn_start()
signal player_turn_end()

signal enemy_turn_start()
signal enemy_turn_end()
