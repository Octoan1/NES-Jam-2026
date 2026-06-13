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
var enemy: CharacterBody2D
var player: CharacterBody2D

# death book:
var death_book_timer: Timer

# meteor:
var meteor_timer: Timer
const METEOR = preload("uid://cl4v4vyxveypp")

# mister sword:
var mister_sword_timer: Timer

# ghost tape:
var ghost_tape_timer: Timer

# gold_ring:
var gold_ring_active: bool = false
var start_ring_timer: bool = false
var player_dodge_chance: float
var max_madness: float = 5.0
var current_madness: float = 0.0


func _ready():
	randomize()
	current_round = 0
	reset_relics()

func add_relic(item: Relic):
	inventory.append(item)
	#print("Relic added to inventory successfully.")
	#print("Current inventory: ", inventory)
	#print("Current relic pool: ", relics)
	#self.call(item.effect_name)

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
	enemy = CharacterBody2D.new()
	if current_round % 2 == 0:
		main_scene = bosses[0].instantiate()
	else:
		main_scene = bosses[1].instantiate()
	
	# instantiate the main scene (containing the boss)
	get_tree().current_scene.add_child(main_scene)
	
	# connect player to the scene
	player = get_tree().get_first_node_in_group("Player")
	if player.health_component.is_connected("died", player_killed) == false:
		player.health_component.connect("died", player_killed)
	
	
	# connect enemy death signal
	if current_round % 2 == 0:
		enemy = main_scene.find_child("StationaryBoss")
		enemy.get_child(0).connect("died", boss_killed)
	else:
		enemy = main_scene.find_child("MothBoss")
		enemy.get_child(0).connect("died", boss_killed)
	
	apply_relics()
	player_dodge_chance = player.get_node("DefenseComponent").dodge_chance
	
	# update UI
	main_scene.find_child("UI").get_child(0).update_health(player.health_component.health, player.health_component.max_health)
	

func apply_relics():
	for relic in inventory:
		self.call(relic.effect_name)

func disable_relics():
	if death_book_timer:
		death_book_timer.stop()
	if meteor_timer:
		meteor_timer.stop()
	if mister_sword_timer:
		mister_sword_timer.stop()
	if ghost_tape_timer:
		ghost_tape_timer.stop()
	if gold_ring_active:
		current_madness = 0
		gold_ring_active = false
		start_ring_timer = false

func boss_killed():
	canvas_layer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	
	disable_relics()
	
	main_scene.queue_free()
	relic_reward_scene = RELIC_REWARD.instantiate()
	canvas_layer.add_child(relic_reward_scene)
	current_round += 1

func player_killed():
	
	disable_relics()
	
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
func _process(delta):
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
	
	if gold_ring_active:
		if player.sprite.animation == "default":
			# set the player's dodge chance to 100% just once
			if start_ring_timer == false:
				player.get_node("DefenseComponent").dodge_chance = 1
				start_ring_timer = true
			current_madness += delta
			
			
		
		if player.sprite.animation != "default":
			if start_ring_timer == true:
				player.get_node("DefenseComponent").dodge_chance = player_dodge_chance
				start_ring_timer = false
			current_madness -= delta
		
	
	if current_madness >= max_madness:
		current_madness = 0
		#gold_ring_active = false
		kill_player()
	
	if current_madness <= 0:
		current_madness = 0
	

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
	print("Lucky coin active")
	player.get_node("StatComponent").crit_mult = 2
	player.get_node("StatComponent").crit_chance = 0.5
	
	# downside:
	player.get_node("StatComponent").critical_fail = true
	
	print("Player crit mult: ", player.get_node("StatComponent").crit_mult)
	print("Player crit chance: ", player.get_node("StatComponent").crit_chance)
	print("Player critical fail: ", player.get_node("StatComponent").critical_fail)
	

# You deal more damage the lower health you have
# You take double damage
func AncientMask():
	player.find_child("HealthComponent").damaged.connect(strengthen_player)
	
	# if enemy attack mult is default, just set it to 2
	# otherwise, (say, there is another attack mult in play) add them together
	if enemy.get_node("StatComponent").attack_mult == 1:
		enemy.get_node("StatComponent").attack_mult = 2
	else:
		enemy.get_node("StatComponent").attack_mult += 2

func strengthen_player():
	var player_health = player.find_child("HealthComponent").health
	
	if player_health <= 12 and player_health > 8:
		player.get_node("StatComponent").attack_mult = 2
	elif player_health <= 8 and player_health > 4:
		player.get_node("StatComponent").attack_mult = 3
	elif player_health <= 4 and player_health > 0:
		player.get_node("StatComponent").attack_mult = 4



# 10% chance to ignore an instance of damage.
# 10% chance to take double damage
func LuckyDice():
	# pro and con modify player, so this will be handled
	# in the 'begin_boss()'
	player.get_node("DefenseComponent").dodge_chance = 0.1
	enemy.get_node("StatComponent").crit_mult += 2
	enemy.get_node("StatComponent").crit_chance = 0.1

# Doubles the positive effect of the next relic.
# Doubles the negative effect of the next relic.
func MonkeyPaw():
	print("How dubious.")

# Meteors occasionally fall from the sky
func Meteors():
	meteor_timer = Timer.new()
	add_child(meteor_timer)
	
	
	meteor_timer.wait_time = 5.0
	meteor_timer.one_shot = true
	
	meteor_timer.timeout.connect(spawn_meteor)
	meteor_timer.start()
	

func spawn_meteor():
	print("METEOR CHANCE")
	var meteor_chance = randi_range(0, 3)
	print("ROLLED: ", meteor_chance)
	if meteor_chance == 0:
		print("METEOR SPAWNED")
		var meteor = METEOR.instantiate()
		var screen_left = 0
		var screen_right = get_viewport().get_visible_rect().size.x
		var screen_top = 0
		
		var meteor_x = randi_range(screen_left, screen_right)
		var meteor_y = screen_top
		meteor.global_position = Vector2(meteor_x, meteor_y)
		
		meteor.target = Vector2(meteor_x, meteor_y + 10)
		
		meteor.move_speed = 30
		main_scene.add_child(meteor)
	meteor_timer.start()

# The player attacks faster
# Must beat the boss in 50 seconds or you die
func GhostTape():
	ghost_tape_timer = Timer.new()
	add_child(ghost_tape_timer)
	
	ghost_tape_timer.wait_time = 50.0
	ghost_tape_timer.one_shot = true
	
	ghost_tape_timer.timeout.connect(kill_player)
	
	player.attack_duration = player.attack_duration / 2
	player.attack_delay = player.attack_delay / 2
	ghost_tape_timer.start()

func kill_player():
	player.find_child("HealthComponent").modify_health(-999.0)

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
	
	player.health_component.max_health = 1
	player.health_component.health = 1
	death_book_timer.start()
	
	# negative effect:
	# handled in the 'begin_boss()' method
	

# When standing still you are invulnerable
# You cannot attack while invulnerable, nor survive for more than 5 seconds in this state.
func GoldRing():
	gold_ring_active = true

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
	

# Damaging the boss heals you
# You lose health over time
func MisterSword():
	# timer setup
	mister_sword_timer = Timer.new()
	add_child(mister_sword_timer)
	mister_sword_timer.wait_time = 1.5
	mister_sword_timer.timeout.connect(damage_player)
	mister_sword_timer.start()
	
	enemy.find_child("HealthComponent").damaged.connect(heal_player)
	

func damage_player():
	player.find_child("HealthComponent").modify_health(-1.0)
	mister_sword_timer.start()

func heal_player():
	player.find_child("HealthComponent").modify_health(1.0)
