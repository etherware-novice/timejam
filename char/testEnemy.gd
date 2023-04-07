extends AnimatedSprite2D

signal endTurn

func _ready():
	print("yey")


func doAttack(player):
	scale.y = scale.y / 2
	await get_tree().create_timer(5).timeout
	scale.y = scale.y * 2
	print("enemy atk")
	endTurn.emit()
