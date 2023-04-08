extends enemy

func _ready():
	super()
	displayName = "player"

func recDmg(damage):
	super(damage)
	print(damage)
