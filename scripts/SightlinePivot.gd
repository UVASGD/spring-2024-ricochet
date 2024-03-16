extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_parent().get_parent().get_parent().get_node("Player").get_node("CharacterBody2D").global_position)
