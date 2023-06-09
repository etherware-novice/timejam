extends CharacterBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	if player.overworldRespawnPos:
		position = player.overworldRespawnPos
	randomize()
	pass # Replace with function body.



func _process(delta):
	if player.cutscene:
		return
	
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * 400
		if velocity.y < 0:
			$AnimatedSprite2D.play("up")
			player.overworldFacing = 3
		elif velocity.y > 0:
			$AnimatedSprite2D.play("down")
			player.overworldFacing = 2
		elif velocity.x != 0:
			$AnimatedSprite2D.play("right")
			var isLeft = velocity.x < 0
			$AnimatedSprite2D.flip_h = isLeft
			if isLeft:
				player.overworldFacing = 4
			else:
				player.overworldFacing = 1
			
	else:
		$AnimatedSprite2D.stop()
	
	
func _physics_process(delta):
	move_and_slide()
	velocity = Vector2.ZERO
