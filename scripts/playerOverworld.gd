extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Camera2D.make_current()
	pass # Replace with function body.



func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
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
		elif velocity.y > 0:
			$AnimatedSprite2D.play("down")
		elif velocity.x != 0:
			$AnimatedSprite2D.play("right")
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta 
