extends Control
@onready var start_button: Button = $Panel/Buttons/StartButton

signal start_game

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	emit_signal("start_game")

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
