extends Area2D

@export var dialogLoaded : int = 0
var active

func _ready():
	active = false
	get_tree().create_timer(2).timeout.connect(func(): active = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if not active:
		return
	if area.name == "player":
		constants.loadDialog(0)
