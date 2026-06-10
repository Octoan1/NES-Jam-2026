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
const TOY_TRUCK = preload("uid://bcjhgc20lxg20")
const ANCIENT_MASK = preload("uid://mdewx4gditu")
const BOOK_OF_DEATH = preload("uid://dw7jce60m4p50")


# relic vars
var inventory: Array[Relic]
var relics: Array[Relic]

# scene loading vars
var main_scene: Node2D
const MAIN = preload("uid://cqfkwrq6ehxx5")
const STATIONARY_BOSS_FIGHT = preload("uid://dcn8lbmn0g8f5")
#const MOTH_BOSS_FIGHT = preload("uid://foypvvwdikos")
const MOTH_BOSS_FIGHT = preload("uid://dibbyk4wp1w6l")


var relic_reward_scene = Control
const RELIC_REWARD = preload("uid://b3klv6pypfa8n")

var title_screen_scene = Control
const MAIN_MENU = preload("uid://xsjlb0si8fwb")

var canvas_layer: CanvasLayer

# level management vars
var bosses = [STATIONARY_BOSS_FIGHT, MOTH_BOSS_FIGHT]
var current_round: int = 0

# relic relevant vars:
var death_book_timer: Timer
var lucky_dice_active = false

func _ready():
	current_round = 0
	reset_relics()

func add_relic(item: Relic):
	inventory.append(item)
	print("Relic added to inventory successfully.")
	print("Current inventory: ", inventory)
	print("Current relic pool: ", relics)
	self.call(item.effect_name)

func update_properties():
	pass
	#print(inventory.size())
	#for item in inventory:
		#self.call(item.effect_name)

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
	ANCIENT_MASK,
	TOY_TRUCK,
	BOOK_OF_DEATH
	]

func begin_boss():
	if current_round % 2 == 0:
		main_scene = bosses[0].instantiate()
	else:
		main_scene = bosses[1].instantiate()
	
	# instantiate the main scene (containing the boss)
	get_tree().current_scene.add_child(main_scene)
	
	# connect player to the scene
	var player = get_tree().get_first_node_in_group("Player")
	if player.health_component.is_connected("died", player_killed) == false:
		player.health_component.connect("died", player_killed)
	
	# modify the player per its relics
	if death_book_timer:
		player.health_component.max_health = 1
		player.health_component.health = 1
		death_book_timer.start()
	if lucky_dice_active:
		player.defense_component.dodge_chance = 0.1
		# TODO: Make player have a 0.1 (10%) chance to take double damage
		pass
		
	
	for child in main_scene.get_children():
		# if StationaryBoss: Connect death signal
		if child.name == "StationaryBoss":
			child.get_child(0).connect("died", boss_killed)
		elif child.name == "MothBoss":
			child.get_child(0).connect("died", boss_killed)
		
		# update the hud
		if child.name == "UI":
			child.get_child(0).update_health(player.health_component.health, player.health_component.max_health)
		
	

func boss_killed():
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	# check for death book relic
	if death_book_timer:
		death_book_timer.stop()
	
	main_scene.queue_free()
	relic_reward_scene = RELIC_REWARD.instantiate()
	canvas_layer.add_child(relic_reward_scene)
	current_round += 1

func player_killed():
	# check for death book relic
	if death_book_timer:
		death_book_timer.stop()
	
	# take player back to main menu
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	main_scene.queue_free()
	title_screen_scene = MAIN_MENU.instantiate()
	canvas_layer.add_child(title_screen_scene)
	title_screen_scene.connect("start_game", begin_boss)
	
	# reset player inventory and relic pool
	reset_relics()
	current_round = 0

func relic_selected(relic: Relic):
	# add relic to inventory, and remove from overall pool of relics
	var chosen_relic_index = relics.find(relic)
	relics.remove_at(chosen_relic_index)
	add_relic(relic)
	
	# update player and game properties, given the player's inventory
	update_properties()
	
	# instantiate the boss scene
	call_deferred("begin_boss")

# DEBUG COMMANDS
func _process(_delta):
	if Input.is_action_just_pressed("boss_1"):
		debug_boss_kill()
		current_round = 0
		await get_tree().create_timer(0.01).timeout
		begin_boss()
	
	if Input.is_action_just_pressed("boss_2"):
		debug_boss_kill()
		current_round = 1
		await get_tree().create_timer(0.01).timeout
		begin_boss()

func debug_boss_kill():
	# check for death book relic
	if death_book_timer:
		death_book_timer.stop()
	
	if main_scene:
		main_scene.queue_free()
	
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	if canvas_layer.get_child(0):
		print(canvas_layer.get_child(0))
		canvas_layer.get_child(0).queue_free()
	

#======= item effects ========

# player has a 50% chance to deal double damage
# player has a 50% chance to deal 0 damage
func LuckyCoin():
	print("So lucky!")

# Each time the player attacks the boss, their attack becomes stronger
# Every 5 seconds passed without attacking the boss, the player's attack becomes weaker
func AncientMask():
	print("Stony!")

# 10% chance to ignore an instance of damage.
# 10% chance to take double damage
func LuckyDice():
	# pro and con modify player, so this will be handled
	# in the 'begin_boss()'
	lucky_dice_active = true
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
	# positive effect:
	death_book_timer = Timer.new()
	add_child(death_book_timer)
	
	death_book_timer.wait_time = 60.0
	death_book_timer.one_shot = true
	
	death_book_timer.timeout.connect(boss_killed)
	
	# negative effect:
	# handled in the 'begin_boss()' method
	

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
