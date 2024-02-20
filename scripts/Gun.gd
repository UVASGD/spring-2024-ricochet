extends Node2D

@onready var killRayCast := $Gun2/KillRayCast2D
@onready var gunSprite := $Gun2/GunSprite
@onready var pickupIcon := $"../PlayerPickupArea/PickupIcon"

# Weapon names to weapon ids.
enum weapons {REVOLVER = 0, SHOTGUN = 1, SNIPER = 2}

var gun_storage = {}
var active_gun = weapons.REVOLVER

# Called when the node enters the scene tree for the first time.
func _ready():
	pickupIcon.hide()
	for weapon_id in weapons.keys():
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

func swapGun(newWeapon: weapons) -> void:
	active_gun = newWeapon
	gunSprite.play(weapons.find_key(active_gun).to_lower())

func _on_pickup_area_area_entered(area: Object):
	if area.name == "PickupArea":
		pickupIcon.show()

func _on_player_pickup_area_area_exited(area):
	if area.name == "PickupArea":
		pickupIcon.hide()
