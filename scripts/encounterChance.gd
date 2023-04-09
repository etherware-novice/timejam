extends Area2D
class_name encounter

@export var possibleSpawn : Dictionary = {0: 0.5, 1: 0.25}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.name == "player":
		$CollisionShape2D.set_deferred("disabled", true)
		var chances = 10
		var enemy = 0
		
		while chances > 0:
			enemy = possibleSpawn.keys()[randi() % possibleSpawn.size()]
			if randf() < possibleSpawn[enemy]:
				break
			chances += 1
		
		constants.loadBattle(area.get_global_transform_with_canvas().get_origin(), enemy)
