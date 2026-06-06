extends Control

@onready var relic_1: Panel = $Panel/Relic1
@onready var relic_2: Panel = $Panel/Relic2
@onready var relic_3: Panel = $Panel/Relic3

var relic_choices: Array[Relic]

func _ready():
	randomize()
	fill_rewards()
	relic_1.get_child(6).grab_focus()

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

func _on_relic_1_relic_selected(relic: Relic) -> void:
	GameManager.relic_selected(relic)
	self.queue_free()

func _on_relic_2_relic_selected(relic: Relic) -> void:
	GameManager.relic_selected(relic)
	self.queue_free()

func _on_relic_3_relic_selected(relic: Relic) -> void:
	GameManager.relic_selected(relic)
	self.queue_free()
