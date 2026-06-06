extends Panel

@onready var relic_name: Label = $RelicName
@onready var relic_description: Label = $RelicDescription
@onready var relic_icon: TextureRect = $RelicIcon
@onready var relic_pro: Label = $RelicPro
@onready var relic_con: Label = $RelicCon

func display_relic(relic_data):
	relic_name.text = relic_data.name
	relic_description.text = relic_data.description
	relic_icon.texture = relic_data.icon
	relic_pro.text = "+" + relic_data.pro
	relic_con.text = "-" + relic_data.con
