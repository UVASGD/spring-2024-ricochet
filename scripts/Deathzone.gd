extends Area2D
@onready var player = get_parent().get_node("Player").get_node("CharacterBody2D")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	pass

func _on_body_entered(body):
	if body == player:
		get_tree().reload_current_scene()
