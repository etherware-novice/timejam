extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if player.new == 0:
		$player/AnimatedSprite2D.animation = "right"
		return
	await get_tree().create_timer(3).timeout
	$player/AnimatedSprite2D.play("wake")
	await constants.loadDialog(1)
	$player/AnimatedSprite2D.animation = "right"
	player.new = 0
	player.cutscene = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
