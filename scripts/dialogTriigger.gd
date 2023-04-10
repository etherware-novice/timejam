extends Area2D

@export var dialogLoaded : int = 0
@export var lockPlayer : bool = false
var active

func _ready():
	active = false
	get_tree().create_timer(2).timeout.connect(func(): active = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if not active:
		return
	if body.name == "player":
		player.overworldRespawnPos = body.position
		if lockPlayer:
			player.cutscene = 1
		await constants.loadDialog(dialogLoaded)
		if lockPlayer:
			player.cutscene = 0


