extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	constants.battleTransition.connect(startAnim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$AnimatedSprite2D.stop()
	pass

func startAnim(start):
	$AnimatedSprite2D.position = start
	
	var tweener = get_tree().create_tween()
	tweener.tween_property($AnimatedSprite2D, "position", $Marker2D.position, $Timer.wait_time * 4)
	tweener.finished.connect(func(): get_tree().change_scene_to_file("res://scenes/battle_scene.tscn"))
	
	var rot = player.overworldFacing
	var loop = 0
	
	$Timer.start()
	while true:
		$AnimatedSprite2D.flip_h = false
		match rot:
			1:
				$AnimatedSprite2D.animation = "right"
			2:
				$AnimatedSprite2D.animation = "down"
				rot = 1
			3:
				$AnimatedSprite2D.animation = "up"
				rot = 1
			4:
				$AnimatedSprite2D.animation = "right"
				$AnimatedSprite2D.flip_h = true
				rot = 2
		$AnimatedSprite2D.frame = loop
		loop += 1
		await $Timer.timeout
