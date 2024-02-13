extends Node2D

@onready var killRayCast := $Gun2/KillRayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	var hit_collider : Object = killRayCast.get_collider()
	if hit_collider and hit_collider.name == "Enemy":
		if Input.is_action_just_pressed("Shoot"):
			print("enemy killed")
