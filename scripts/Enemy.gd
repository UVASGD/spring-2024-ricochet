extends CharacterBody2D


var inArea = false
var isAlert = false
var inSight = false
var Speed = 0
const PlayerFriction = 0.07
const TopSpeed = 75.0
const SpeedInterval = 5
const VelocityInterval = 5
const ShootInterval = 1
@onready var player = get_parent().get_parent().get_node("Player").get_node("CharacterBody2D")


func _ready() -> void:
	$Pivot/Sightline.connect("playerSeen", playerSeen)
	$Pivot/Sightline.connect("playerNotSeen", playerNotSeen)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#print(player)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if isAlert:
		var positionDif = player.global_position.x - self.global_position.x
		var direction = positionDif / abs(positionDif)
		print(abs(positionDif))
		if abs(positionDif) > 200 and not inSight:
			Speed = move_toward(Speed, TopSpeed, SpeedInterval)
			velocity.x = direction * Speed
		else:
			Speed = move_toward(Speed, 0, SpeedInterval)
			velocity.x = direction * Speed

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body == player:
		inArea = true
		print("Player is in Area:", inArea)


func _on_area_2d_body_exited(body):
	if body == player:
		inArea = false
		print("Player is in Area:", inArea)


func playerSeen():
	isAlert = true
	inSight = true
	#print("player seen", isAlert, inSight)

func playerNotSeen():
	inSight = false
	#print("player not seen", isAlert, inSight)
