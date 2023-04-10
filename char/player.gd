extends Node

var overworldFacing = 0
var overworldRespawnPos = null
var nextEncounter = 0
var cutscene = 1
var new = 1

var hp
var maxHp = 20
var displayName = "player"

func _ready():
	hp = maxHp
