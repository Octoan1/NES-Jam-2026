extends Node

func _ready():
	pass

func _on_main_menu_start_game() -> void:
	GameManager.begin_boss()
