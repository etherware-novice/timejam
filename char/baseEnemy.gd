extends Area2D
class_name enemy

signal endTurn
signal updateHp(health)

var displayName = "null"
var maxHp = 10
var hp : set = _hp_setter
var targetable = false
var canAttack = false

func _ready():
	hp = maxHp

func doAttack(player):
	await get_tree().create_timer(2)
	endTurn.emit()

func recDmg(damage):
	hp = hp - damage
	print(hp)
	if hp <= 0:
		die()

func _hp_setter(health):
	hp = health
	updateHp.emit(self)

func die():
	targetable = false
	canAttack = false
	get_tree().create_timer(20).timeout.connect(queue_free)
