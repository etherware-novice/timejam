extends Node2D

signal finished

var active = false

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
	$ball.position = $ready.position
	active = true

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

	pass
