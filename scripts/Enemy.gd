extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var inArea
var inSight
@onready var player = get_parent().get_parent().get_node("Player")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body == player:
		inArea = true
		print("Player is in Area:", inArea)


func _on_area_2d_body_exited(body):
	if body == player:
		inArea = false
		print("Player is in Area:", inArea)
