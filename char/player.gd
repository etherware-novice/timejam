extends enemy

var overworldFacing = 0
var overworldRespawnPos = null
var nextEncounter = 0


func _ready():
	super()
	displayName = "player"

func recDmg(damage):
	super(damage)
	print(damage)
