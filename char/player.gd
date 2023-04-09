extends enemy

var overworldFacing = 0
var nextEncounter = 0

func _ready():
	super()
	displayName = "player"

func recDmg(damage):
	super(damage)
	print(damage)
