extends Node

@onready var main_menu: Control = $"../CanvasLayer/MainMenu"
const RELIC_REWARD = preload("uid://b3klv6pypfa8n")

func _ready():
	pass

func _on_main_menu_start_game() -> void:
	RELIC_REWARD.instantiate()
	
	if main_menu:
		main_menu.queue_free()
	
