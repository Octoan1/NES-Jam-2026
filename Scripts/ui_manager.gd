extends Node

@onready var main_menu: Node2D = $"../MainMenu"

func _ready():
	pass

func _on_main_menu_start_game() -> void:
	main_menu.queue_free()
	#game_scene.instantiate()
