extends Area2D
class_name encounter

@export var possibleSpawn : Dictionary = {0: 0.5, 1: 0.25}
@export var startChance : float
var active : bool = false

func _ready():
	active = false
	get_tree().create_timer(2).timeout.connect(func(): active = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	constants.loadDialog(0)
	return
	
	if not active:
		return
	if area.name == "player":
		if randf() < startChance:
			active = false
			get_tree().create_timer(2).timeout.connect(func(): active = true)
			return
		var chances = 10
		var enemy = 0
		
		while chances > 0:
			enemy = possibleSpawn.keys()[randi() % possibleSpawn.size()]
			if randf() < possibleSpawn[enemy]:
				break
			chances += 1
		
		player.overworldRespawnPos = area.position
		constants.loadBattle(area.get_global_transform_with_canvas().get_origin(), enemy)
