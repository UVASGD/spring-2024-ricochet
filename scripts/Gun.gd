extends Node2D

@onready var killRayCast := $Gun2/KillRayCast2D
@onready var gunSprite := $Gun2/GunSprite
@onready var pickupIcon := $"../PlayerPickupArea/PickupIcon"
@onready var nozzle := $"Gun2/Nozzle"
@onready var player = get_parent()

var pickupableItem = null
var nearbyArea: Area2D = null

var scenes = [load("res://scenes/revolver_pickup.tscn"), load("res://scenes/shotgun_pickup.tscn"), 
load("res://scenes/sniper_pickup.tscn")]

signal gun_changed(gun_id)

# Weapon names to weapon ids.
enum weapons {REVOLVER = 0, SHOTGUN = 1, SNIPER = 2}

# Stores weapon IDs to boolean (whether the player has it in its inventory or not)
var gun_storage = {}
var active_gun := weapons.REVOLVER # <- this will make active_gun = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pickupIcon.hide()
	for weapon_id in weapons.values():
		gun_storage[weapon_id] = false
	gun_storage[weapons.REVOLVER] = true # start the player off with a revolver
	swapGun(weapons.REVOLVER)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	var hit_collider : Object = killRayCast.get_collider()
	if Input.is_action_just_pressed("Shoot"):
		if hit_collider and hit_collider.name == "Enemy":
			print("enemy killed")
	
	# Press W to swap.
	if Input.is_action_just_pressed("Swap"):
		swapGun(get_inactive_gun())
	
	# Press S to pick up.
	if Input.is_action_just_pressed("Pickup") and pickupableItem != null:
		# if player already has this gun don't run logic
		if !gun_storage[weapons[pickupableItem]]: 
			# delete the pickup
			nearbyArea.get_parent().queue_free()
			
			if !has_only_one_gun():
				var instance: Node2D
				instance = scenes[active_gun].instantiate()
				get_parent().get_parent().add_child(instance)
				instance.position = player.position
				remove_gun(active_gun)
			add_gun(weapons[pickupableItem])
			swapGun(weapons[pickupableItem])
			
func has_only_one_gun() -> bool: # used only for the beginning of the game, when the player starts with the revolver
	var num_of_guns := 0
	for gun in gun_storage:
		if gun_storage[gun]:
			num_of_guns += 1
	return num_of_guns == 1
	
func get_inactive_gun(): 
	# should return the current gun if player only has one gun
	if has_only_one_gun():
		return active_gun
		
	for gun in gun_storage:
			if gun_storage[gun] and gun != active_gun:
				return gun

func swapGun(id: int) -> void:
	active_gun = id
	gun_changed.emit(active_gun)
	print("Gun switched to " + weapons.find_key(active_gun))
	gunSprite.play(weapons.find_key(active_gun).to_lower())

func add_gun(id: int) -> void:
	print("Added to inventory: " + weapons.find_key(id))
	gun_storage[id] = true
	
func remove_gun(id: int) -> void:
	print("Removed from inventory: " + weapons.find_key(id))
	gun_storage[id] = false

func _on_pickup_area_area_entered(area: Area2D):
	if area.name == "PickupArea":
		pickupIcon.show()
		nearbyArea = area
		# For all pickups, please name them in the format of Name_Pickup
		var parentName: String = area.get_parent().name
		var gunName: String = parentName.left(parentName.find("_"))
		pickupableItem = gunName.to_upper()

func _on_player_pickup_area_area_exited(area: Area2D):
	if area.name == "PickupArea":
		pickupIcon.hide()
		pickupableItem = null
		nearbyArea = null
		
