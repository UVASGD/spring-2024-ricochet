extends CharacterBody2D

var Speed = 0
const PlayerFriction = 0.7
const TopSpeed = 200.0
const SpeedInterval = 15
const VelocityInterval = 25
const ShootInterval = 1
var Shot = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#Initializes vectors and values needed for shot calculation
func _physics_process(delta):
	# var ShootVector = (get_global_mouse_position() - $".".position).normalized()
	var deg = int(rad_to_deg($Pivot.get_rotation())) % 360
	if deg < 0:
		deg = deg + 360
	var ShootVector = Vector2.RIGHT.rotated(deg_to_rad(deg))
	var power = 0
	#If shooting, calculate power based on distance to closest wall/floor, move in direction opposite mouse
	if Input.is_action_just_pressed("Shoot"):
		power = coolCalcRayCast(deg)
		print("Angle: " + str(deg))
		print("Power: " + str(power))
		velocity += -ShootVector*power
		Shot = true
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("walkLeft", "walkRight")
	if Shot: #if just fired, ignore x axis interpolation and allow player to fly through the air until landed
		if is_on_floor():
			Shot = false
	elif not is_on_floor():
		# Logic to decelerate mid-air. Subject to change/removal
		# Players can immediately decelerate in the x direction after launching if they hold in the opposite direction.
		# It may be a good idea to only allow this x frames after the player is first airborne.
		# Currently decelerates 5 velocity per frame.
		var decel_rate = 5
		if velocity.x > 0: 
			if Input.is_action_pressed("walkLeft"):
				velocity.x -= decel_rate
				# velocity.y = 0
				if velocity.x < 0: velocity.x = 0
		elif velocity.x < 0:
			if Input.is_action_pressed("walkRight"):
				velocity.x += decel_rate
				# velocity.y = 0
				if velocity.x > 0: velocity.x = 0
	elif direction and is_on_floor():
		Speed = move_toward(Speed, TopSpeed, SpeedInterval)
		velocity.x = direction * Speed
	elif is_on_floor():
		Speed = move_toward(Speed, 0, SpeedInterval)
		velocity.x = move_toward(velocity.x, 0, VelocityInterval)
	move_and_slide()
	
func coolCalcRayCast(deg: int) -> int:
	var power = 0
	var raycast := $Pivot/Gun2/RayCast2D
	var origin 	= $Pivot/Gun2/RayCast2D.global_transform.origin
	if $Pivot/Gun2/RayCast2D.is_colliding():
		var point = $Pivot/Gun2/RayCast2D.get_collision_point()
		var distance = origin.distance_to(point)
		power = (500-distance)
	return power
	
	
	
func calcRayCast(deg) -> int:
	var Origin = $DownRayCast.global_transform.origin #gets center of player relative to down raycast node
	var RightPower = 0
	var UpPower = 0
	var DownPower = 0
	var LeftPower = 0
#checks pairs of raycasts depending on angle of gun, decides power based on distance between player & wall
	if 270 < deg and deg < 360: 
		if $RightRayCast.is_colliding():
			var RightPoint = $RightRayCast.get_collision_point()
			var RightDistance = Origin.distance_to(RightPoint)
			RightPower = (500-RightDistance) #* (1-(abs(deg-360.0)/360.0))
		if $UpRayCast.is_colliding():
			var UpPoint = $UpRayCast.get_collision_point()
			var UpDistance = Origin.distance_to(UpPoint)
			UpPower = (500-UpDistance) #* (1-(abs(deg-270.0)/270.0))
		return RightPower if RightPower > UpPower else UpPower
	if 180 < deg and deg <= 270:
		if $LeftRayCast.is_colliding():
			var LeftPoint = $LeftRayCast.get_collision_point()
			var LeftDistance = Origin.distance_to(LeftPoint)
			LeftPower = (500-LeftDistance) #* (1-(abs(deg-180.0)/180.0))
		if $UpRayCast.is_colliding():
			var UpPoint = $UpRayCast.get_collision_point()
			var UpDistance = Origin.distance_to(UpPoint)
			UpPower = (500-UpDistance) #* (1-(abs(deg-270.0)/270.0))
		return LeftPower if LeftPower > UpPower else UpPower
	if 90 < deg and deg <= 180:
		if $LeftRayCast.is_colliding():
			var LeftPoint = $LeftRayCast.get_collision_point()
			var LeftDistance = Origin.distance_to(LeftPoint)
			LeftPower = (500-LeftDistance) #* (1-(abs(deg-180.0)/180.0))
		if $DownRayCast.is_colliding():
			var DownPoint = $DownRayCast.get_collision_point()
			var DownDistance = Origin.distance_to(DownPoint)
			DownPower = (500-DownDistance) #* (1-(abs(deg-90.0)/90.0))
		return LeftPower if LeftPower > DownPower else DownPower
	if 0 <= deg and deg <= 90:
		if $RightRayCast.is_colliding():
			var RightPoint = $RightRayCast.get_collision_point()
			var RightDistance = Origin.distance_to(RightPoint)
			RightPower = (500-RightDistance) #* (abs(deg-90.0)/90.0)
		if $DownRayCast.is_colliding():
			var DownPoint = $DownRayCast.get_collision_point()
			var DownDistance = Origin.distance_to(DownPoint)
			DownPower = (500-DownDistance) #* (1-(abs(deg-90.0)/90.0))
		return RightPower if RightPower > DownPower else DownPower
	return 0
	
