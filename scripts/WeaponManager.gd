extends Node

var weaponInventory = []
var weaponIndicator = 0

var currentWeapon = null
var nextWeapon: String

var weaponList = {}

@export var weaponResources: Array[weaponResource]
@export var startWeapons: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():	
	Initialize(startWeapons)

func _input(event):
	if event.is_action_pressed("Swap"):
		match(weaponIndicator):
			0:
				weaponIndicator = 1
				exit(weaponInventory[weaponIndicator])
			1:
				weaponIndicator = 0
				exit(weaponInventory[weaponIndicator])
	

func Initialize(startWeapons: Array):
	for weapon in weaponResources:
		weaponList[weapon.weaponName]  = weapon
	
	for weapon in startWeapons:
		weaponInventory.push_back(weapon)
		
	currentWeapon = weaponList[weaponInventory[0]]
	enter()

func enter():
	pass

func exit(_next_weapon: String):
	nextWeapon = _next_weapon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
