extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("scrollup")
	$logo.play("default")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/story.tscn")
