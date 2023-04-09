extends Node

signal battleTransition(position)

const charLookup = [
	"res://char/testEnemy"
]

# uses charLookup id
const senarioLookup = [
	[0],
	[0, 0]
]

func loadBattle(position, encounter):
	player.nextEncounter = encounter
	get_tree().change_scene_to_file("res://scenes/battle_transition.tscn")
	get_tree().create_timer(0.5).timeout.connect(func(): battleTransition.emit(position))
	#$enemy1.position = position
