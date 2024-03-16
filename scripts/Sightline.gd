extends RayCast2D

signal playerSeen
signal playerNotSeen

@onready var inArea = get_parent().get_parent().inArea

@onready var player = get_parent().get_parent().get_parent().get_parent().get_node("Player").get_node("CharacterBody2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inArea = get_parent().get_parent().inArea
	if $".".is_colliding() and inArea: #if sightline raycast is colliding with an object and player is inArea
		var collidedObject = $".".get_collider()
		if collidedObject == player:
			emit_signal("playerSeen")
		else:
			emit_signal("playerNotSeen")
