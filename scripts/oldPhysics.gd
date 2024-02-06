extends CharacterBody2D


const SPEED = 300.0
const SPRINTSPEED = 500.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent: float

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak * -1.0
@onready var jump_gravity : float = (-4.0) / (jump_time_to_peak * jump_time_to_peak) * -1.0
@onready var fall_gravity : float = (-4.0) / (jump_time_to_descent * jump_time_to_descent) * -1.0


const SPRINTBAR_RATE = .5

var can_bar = false	

@onready var SprintJuice = $Camera2D/MeshInstance2D

var SprintMeter = 100
var Speed = SPEED
var SpeedAdd = (SPRINTSPEED / SPEED) * 2
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func sprint_bar():
	await get_tree().create_timer(SPRINTBAR_RATE).timeout
	can_bar = true

func get_gravity() -> float:
		return jump_gravity if velocity.y < 0.0 else fall_gravity
		
func jump():
	velocity.y = jump_velocity

func _physics_process(delta):
	# Add the gravity.
	velocity.y -= get_gravity() * delta 
	print(velocity.y)
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("walkLeft", "walkRight")
	if direction:
		if Input.is_action_pressed("Sprint"):
			if SprintMeter > 0.0:
				if Speed < SPRINTSPEED:
					Speed += SpeedAdd
					velocity.x = direction * Speed
				sprint_bar()
				if can_bar == true:
					SprintMeter -=  1
					SprintJuice.scale.x -= 1.5
					SprintJuice.position.y += .75
					can_bar = false
			else:
				if Speed > SPEED:
					Speed -= SpeedAdd
				velocity.x = direction * Speed
		else:
			if Speed > SPEED:
				Speed -= SpeedAdd
			velocity.x = direction * Speed
			if SprintMeter < 100:
				sprint_bar()
				if can_bar == true:
					SprintMeter += 1
					SprintJuice.scale.x += 1.5
					SprintJuice.position.y -= .75
					can_bar = false
	else:
		velocity.x = move_toward(velocity.x, 0, 25)
		if SprintMeter <  100:
			sprint_bar()
			if can_bar == true:
				SprintMeter += 1
				SprintJuice.scale.x += 1.5
				SprintJuice.position.y -= .75
				can_bar = false

	move_and_slide()
