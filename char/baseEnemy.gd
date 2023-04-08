extends Area2D
class_name enemy

signal endTurn

var hp = 10
var targetable = false
var canAttack = false

func doAttack(player):
	await get_tree().create_timer(2)
	endTurn.emit()

func recDmg(damage):
	hp -= damage
	print(hp)
	if hp <= 0:
		die()

func die():
	targetable = false
	canAttack = false
	get_tree().create_timer(20).timeout.connect(queue_free)
