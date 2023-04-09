extends enemy



func _ready():
	super()
	displayName = "player"

func _hp_setter(value):
	super(value)
	player.hp = value

func _hp_getter():
	return player.hp
