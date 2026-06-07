extends Control
@onready var start_button: Button = $Panel/Buttons/StartButton
@onready var options_button: Button = $Panel/Buttons/OptionsButton
@onready var quit_button: Button = $Panel/Buttons/QuitButton


@onready var selector: Sprite2D = $Panel/Selector



signal start_game

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	emit_signal("start_game")
	self.queue_free()

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Focus selector logic
func _on_start_button_focus_entered() -> void:
	selector.global_position.x = start_button.global_position.x + 90
	selector.global_position.y = start_button.global_position.y + 8.5

func _on_options_button_focus_entered() -> void:
	selector.global_position.x = options_button.global_position.x + 90
	selector.global_position.y = options_button.global_position.y + 8.5

func _on_quit_button_focus_entered() -> void:
	selector.global_position.x = quit_button.global_position.x + 90
	selector.global_position.y = quit_button.global_position.y + 8.5
