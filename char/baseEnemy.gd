extends Area2D
class_name enemy

signal endTurn
signal updateHp(health)

var displayName = "null"
var maxHp = 10
var hp : set = _hp_setter, get = _hp_getter
var targetable = false
var canAttack = true


var animate = true

func roundStart():
	if hp == null:
		hp = maxHp
	$AnimatedSprite2D.animation_finished.connect(func(): $AnimatedSprite2D.play("idle"))

func doAttack(player):
	await get_tree().create_timer(2)
	endTurn.emit()

func recDmg(damage):
	hp = hp - damage
	if hp <= 0:
		die()
	else:
		$AnimatedSprite2D.play("hurt")

func _hp_setter(health):
	hp = health
	updateHp.emit(self)

func _hp_getter():
	return hp

func die():
	targetable = false
	canAttack = false
	get_tree().create_timer(20).timeout.connect(queue_free)
	var spr = $AnimatedSprite2D
	if spr:
		$AnimatedSprite2D.play("die")
		$AnimatedSprite2D.animation_finished.connect(func(): $AnimatedSprite2D.play("dieLoop"))
