extends Node

@onready var main_menu: Control = $"../CanvasLayer/MainMenu"

func _ready():
	pass

func _on_main_menu_start_game() -> void:
	#game_scene.instantiate()
	
	if main_menu:
		main_menu.queue_free()
	
