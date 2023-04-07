extends AnimatedSprite2D

signal endTurn

func _ready():
	print("yey")


func doAttack(player):
	await get_tree().create_timer(2).timeout
	print("done")
	endTurn.emit()
