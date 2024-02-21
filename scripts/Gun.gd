extends Node2D

@onready var killRayCast := $Gun2/KillRayCast2D
@onready var gunSprite := $Gun2/GunSprite
@onready var pickupIcon := $"../PlayerPickupArea/PickupIcon"

# Weapon names to weapon ids.
enum weapons {REVOLVER = 0, SHOTGUN = 1, SNIPER = 2}

# Stores weapon IDs to boolean (whether the player has it in its inventory or not)
var gun_storage = {}
var active_gun = weapons.REVOLVER # <- this will make active_gun = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for weapon_id in weapons.values():
		pickupIcon.hide()
		gun_storage[weapon_id] = false
	
	gun_storage[weapons.REVOLVER] = true
	active_gun = weapons.REVOLVER
#	gunSprite.play(weapons.find_key(active_gun).to_lower())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	var hit_collider : Object = killRayCast.get_collider()
	if hit_collider and hit_collider.name == "Enemy":
		if Input.is_action_just_pressed("Shoot"):
			print("enemy killed")
	
	if Input.is_action_just_pressed("Pickup"):
		swapGun(weapons.SNIPER)
	if Input.is_action_just_pressed("Swap"):
		swapGun(weapons.REVOLVER)

func swapGun(id: int) -> void:
	# if gun_storage[id] == true:
		active_gun = id
		gunSprite.play(weapons.find_key(active_gun).to_lower())
	# else:
		# print("Gun change failed (player does not have gun in inventory)")
		
func add_gun(id):
	gun_storage[id] = true
	
func remove_gun(id):
	gun_storage[id] = false

func _on_pickup_area_area_entered(area: Object):
	if area.name == "PickupArea":
		pickupIcon.show()

func _on_player_pickup_area_area_exited(area):
	if area.name == "PickupArea":
		pickupIcon.hide()
