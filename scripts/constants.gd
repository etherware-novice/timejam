extends Node

signal battleTransition(position)

const charLookup = [
	"res://char/testEnemy",
	"res://char/icecream"
]

# uses charLookup id
const senarioLookup = [
	[0],
	[0, 0],
	[1],
	[1, 1, 1]
]

const dialogTable = [
	{ "Lorem ipsum doler": "default",
	"Sit amet": "default",
	"abc": "123" },
	{"Where am I?": "player"},
	{"Oh no, an icecream slime!": "player"},
	{"That was close": "player"},
	{"There's nothing here!": "player",
	"What do we do now...?": "player"}
]

var postDialog = {
	2: func():
		loadBattle(player.overworldRespawnPos, 2),
	4: func():
		get_tree().change_scene_to_file("res://scenes/preboot.gd")
		player.new = 1
}

var postBattle = {
	2: func():
		loadDialog(3)
}

func loadBattle(position, encounter):
	player.nextEncounter = encounter
	get_tree().change_scene_to_file("res://scenes/battle_transition.tscn")
	get_tree().create_timer(0.5).timeout.connect(func(): battleTransition.emit(position))
	#$enemy1.position = position

func loadDialog(id):
	var dArray = dialogTable[id]
	if dArray == null:
		return
	
	var root = get_tree().get_current_scene()
	var box = load("res://scenes/dialog.tscn").instantiate()
	root.add_child(box)
	box.set_owner(root)
	box.start(dArray)
	await box.ended
	if postDialog.has(id):
		postDialog[id].call()
