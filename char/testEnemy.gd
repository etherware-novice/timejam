extends enemy

func _ready():
	print("yey")
	targetable = true
	canAttack = true


func doAttack(player):
	if not canAttack:
		endTurn.emit()
		return
	scale.x = scale.x / 2
	await get_tree().create_timer(5).timeout
	scale.x = scale.x * 2
	print("enemy atk")
	endTurn.emit()

func recDmg(damage):
	super(damage)
	if hp > 0:
		scale.y = scale.y / 2
		get_tree().create_timer(0.5).timeout.connect(func(): scale.y = scale.y * 2)

func die():
	super()
	scale = Vector2(5, 0.5)
