extends Node2D

signal finished

var active = false
var ballVelocity = Vector2(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ready.visible_characters = 0

func start():
	var flash = 3
	$flasher.start()
	while flash > 0:
		$ready.visible_ratio = 1
		await $flasher.timeout
		$ready.visible_ratio = 0
		await $flasher.timeout
		flash -= 1
	
	#                     0,1     1,2   2,4   -1,1
	var flip = ( ( (randi() % 2) + 1 ) * 2 ) - 3
	ballVelocity = Vector2(-1, flip)
	$ball.position = $ready.position + Vector2(300, 0)
	active = true

func stop():
	$ready.visible_ratio = 0
	active = false
	$ball.position = Vector2(-999,-999)
	$paddle.position = Vector2(-999, -999)
	finished.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return
	var velocity = Vector2.ZERO
	var screenSize = get_viewport_rect().size / 2

	
	if Input.is_action_pressed("ui_up"):
		velocity.y =- 1
	if Input.is_action_pressed("ui_down"):
		velocity.y =+ 1
	velocity = velocity.normalized() * 400
	
	
	$paddle.position += velocity * delta
	$paddle.position.x = clamp($paddle.position.x, 0, screenSize.x)
	$paddle.position.y = clamp($paddle.position.y, 0, screenSize.y + 50)
	
	$ball.position += ballVelocity.normalized() * delta * 500
	print($ball.position)
	if $ball.position.y < 0:
		ballVelocity.y = 1
	if $ball.position.y > screenSize.y * 1.5:
		ballVelocity.y = -1
	if $ball.position.x < 0 or $ball.position.x > screenSize.y:
		#stop()
		pass
	


func _on_ball_area_entered(area):
	ballVelocity *= -1


func _on_visible_on_screen_notifier_2d_screen_exited():
	if active:
		stop()
