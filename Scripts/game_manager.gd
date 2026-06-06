extends Node


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

var inventory: Array[Relic]
var relics: Array[Relic]




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
	print("trucky")

# Adds 6 powerful relics into the loot pool. (Can be selected as future rewards.)
# Lose 50% of all stats
func GemGauntlet():
	print("Blockbustery")

# Your sword now shoots a projectile
# Your attacks are slower
func MisterSword():
	print("Legendary")
