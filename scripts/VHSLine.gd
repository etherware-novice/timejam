extends Node2D


func _ready():
	_on_hp_reset_timeout()

func updateHP(char):
	var test = str(char.hp) + " / " + str(char.maxHp) + "   " + char.displayName
	$hpLine.set_text(test)
	$hpReset.start()


func _on_hp_reset_timeout():
	updateHP(player)
	pass # Replace with function body.
