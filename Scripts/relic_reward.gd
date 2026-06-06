extends Control

@onready var relic_1_confirmed: Button = $Panel/Relic1/Relic1Confirmed
@onready var relic_2_confirmed: Button = $Panel/Relic2/Relic2Confirmed
@onready var relic_3_confirmed: Button = $Panel/Relic3/Relic3Confirmed

var relic_choices: Array[Relic]

func _ready():
	randomize()
	fill_rewards()
	relic_1_confirmed.grab_focus()

func fill_rewards():
	var relics_copy = GameManager.relics.duplicate(true)
	for i in range(3):
		# generate a random relic
		if relics_copy.is_empty(): break
		
		var random_index = randi() % relics_copy.size()
		var chosen_relic = relics_copy[random_index]
		relic_choices.append(chosen_relic)
		
		var relic_node = get_node("Panel/Relic" + str(i+1))
		relic_node.display_relic(chosen_relic)
		
		relics_copy.remove_at(random_index)




func _on_relic_1_confirmed_pressed() -> void:
	GameManager.relic_selected(relic_choices[0])
	self.queue_free()

func _on_relic_2_confirmed_pressed() -> void:
	GameManager.relic_selected(relic_choices[1])
	self.queue_free()

func _on_relic_3_confirmed_pressed() -> void:
	GameManager.relic_selected(relic_choices[2])
	self.queue_free()
