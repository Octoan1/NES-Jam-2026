extends Node

# relic data
const LUCKY_COIN = preload("uid://deyngh6fp3m8n")
const CURSED_FINGER = preload("uid://c5u5mt5wxj4op")
const GEM_GAUNTLET = preload("uid://qdi73n2u07dy")
const GHOST_TAPE = preload("uid://bljbanuhony4o")
const GOLD_RING = preload("uid://dxvosg3q6gow4")
const LUCKY_DICE = preload("uid://u5oprj86qys3")
const METEORS = preload("uid://bi65ciq16gnck")
const MISTER_SWORD = preload("uid://lsk0psi5tvrf")
const MONKEY_PAW = preload("uid://dx0s20sx3k6up")
const STONE_MASK = preload("uid://mdewx4gditu")
const TOY_TRUCK = preload("uid://bcjhgc20lxg20")

# relic vars
var inventory: Array[Relic]
var relics: Array[Relic]

# scene loading vars
var main_scene = Node2D
const MAIN = preload("uid://cqfkwrq6ehxx5")

var relic_reward_scene = Control
const RELIC_REWARD = preload("uid://b3klv6pypfa8n")

var title_screen_scene = Control
const MAIN_MENU = preload("uid://xsjlb0si8fwb")

var canvas_layer: CanvasLayer


func _ready():
	reset_relics()
	update_properties()

func add_relic(item: Relic):
	inventory.append(item)
	print("Relic added to inventory successfully.")
	print("Current inventory: ", inventory)
	print("Current relic pool: ", relics)

func update_properties():
	print(inventory.size())
	for item in inventory:
		self.call(item.effect_name)

func reset_relics():
	inventory = []
	relics = [
	LUCKY_COIN,
	CURSED_FINGER,
	GEM_GAUNTLET,
	GHOST_TAPE,
	GOLD_RING,
	LUCKY_DICE,
	METEORS,
	MISTER_SWORD,
	MONKEY_PAW,
	STONE_MASK,
	TOY_TRUCK
	]

func begin_boss():
	main_scene = MAIN.instantiate()
	get_tree().current_scene.add_child(main_scene)
	
	for child in main_scene.get_children():
		# connect player death signal
		if child.name == "Player":
			child.get_child(0).connect("died", player_killed)
		
		# if fighting werewolf: Connect death signal
		if child.name == "WerewolfBossFight":
			for grandchild in child.get_children():
				if grandchild.name == "WerewolfBoss":
					print(grandchild.get_child(0).name)
					grandchild.get_child(0).connect("died", boss_killed)
					continue

func boss_killed():
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	main_scene.queue_free()
	relic_reward_scene = RELIC_REWARD.instantiate()
	canvas_layer.add_child(relic_reward_scene)

func player_killed():
	# take player back to main menu
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	main_scene.queue_free()
	title_screen_scene = MAIN_MENU.instantiate()
	canvas_layer.add_child(title_screen_scene)
	title_screen_scene.connect("start_game", begin_boss)
	
	# reset player inventory and relic pool
	reset_relics()

func relic_selected(relic: Relic):
	# add relic to inventory, and remove from overall pool of relics
	var chosen_relic_index = relics.find(relic)
	relics.remove_at(chosen_relic_index)
	add_relic(relic)
	
	# update player and game properties, given the player's inventory
	update_properties()
	
	# instantiate the boss scene
	call_deferred("begin_boss")

#======= item effects ========

# player has a 50% chance to deal double damage
# player has a 50% chance to deal 0 damage
func LuckyCoin():
	print("So lucky!")

# Each time the player attacks the boss, their attack becomes stronger
# Every 5 seconds passed without attacking the boss, the player's attack becomes weaker
func StoneMask():
	print("Stony!")

# 10% chance to ignore an instance of damage.
# 10% chance to take double damage
func LuckyDice():
	print("How lucky!")

# Doubles the positive effect of the next relic.
# Doubles the negative effect of the next relic.
func MonkeyPaw():
	print("How dubious.")

# Meteors occasionally fall from the sky
func Meteors():
	print("Run!")

# A ghost summon helps you in battle.
# Must beat the boss in 60 seconds or you die
func GhostTape():
	print("Spooky!")

# In battle, 20 fingers will spawn over time. Collect them all to automatically win the fight.
# The boss deals triple damage to the player.
func CursedFinger():
	print("Yummy")

# The boss automatically dies after 60 seconds
# Player has 1 health
func DeathBook():
	print("Deadly")

# When standing still you are invulnerable
# You cannot attack while invulnerable, nor survive for more than 5 seconds in this state.
func GoldRing():
	print("Maddening")

# Move faster
# Floor is slippery
func ToyTruck():
	# positive effect:
	#player.speed = 400.0
	# negative effect:
	pass
	

# Adds 6 powerful relics into the loot pool. (Can be selected as future rewards.)
# Lose 50% of all stats
func GemGauntlet():
	print("Blockbustery")
	# positive effect:
	
	# negative effect:
	#player.speed = player.speed / 2
	#player.dmg = player.dmg / 2
	#player.health = player.health / 2
	#player.dodge_chance = player.dodge_chance / 2
	

# Your sword now shoots a projectile
# Your attacks are slower
func MisterSword():
	print("Legendary")
