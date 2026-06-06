extends Panel

@onready var relic_name: Label = $RelicName
@onready var relic_description: Label = $RelicDescription
@onready var relic_icon: TextureRect = $RelicIcon
@onready var relic_pro: Label = $RelicPro
@onready var relic_con: Label = $RelicCon

var this_relic: Relic
signal relic_selected(relic: Relic)

func display_relic(relic_data):
	relic_name.text = relic_data.name
	relic_description.text = relic_data.description
	relic_icon.texture = relic_data.icon
	relic_pro.text = "+" + relic_data.pro
	relic_con.text = "-" + relic_data.con
	this_relic = relic_data



func _on_relic_1_confirmed_pressed() -> void:
	emit_signal("relic_selected", this_relic)
