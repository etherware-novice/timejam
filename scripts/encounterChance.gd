extends Area2D
class_name encounter

@export var possibleSpawn : Dictionary = {0: 0.5, 1: 0.25}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.name == "player":
		$CollisionShape2D.set_deferred("disabled", true)
		constants.loadBattle(area.get_global_transform_with_canvas().get_origin(), 0)
