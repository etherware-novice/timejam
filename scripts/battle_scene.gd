extends Node2D

var playerMove = false
var selectMark = []
var selectIndex = 0
var selectTrack : set = _setSelectTrack

var turnOrder = []
var subTurn = 0
var turnCount = 0
var nextInput = null

var nextBattleId = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$battleCam.make_current()
	
	var i = 1
	for x in constants.senarioLookup[nextBattleId]:
		var charBase = constants.charLookup[x]
		var spr = get_node("enemy" + str(i))
		spr.script = load(charBase + ".gd")
		spr._ready()  # maybe a bad idea but it worky
		spr.set_process(true)
		spr.sprite_frames = load(charBase + ".tres")
		spr.play()
		spr.connect("endTurn", nextTurn)
		turnOrder.append(spr)
		
		i += 1
	nextTurn()


func nextTurn():
	if subTurn < 1 and not playerMove:
		playerMove = true
		selectTrack = "main"
		return
	subTurn += 1


func _unhandled_key_input(event):
	if selectMark.size() < 2:
		return
	if event.is_action_pressed("ui_left",true):
		selectIndex -= 1
	elif event.is_action_pressed("ui_right",true):
		selectIndex += 1
	selectIndex = clamp(selectIndex, 0, selectMark.size() - 1)
	
	if event.is_action_pressed("ui_accept") and selectIndex == 0:
		if selectTrack == "main":
			selectTrack = "enemy"
		elif selectTrack == "enemy":
			selectTrack = "main"
		selectIndex=0
	$selector.position = selectMark[selectIndex].position
	pass

func _setSelectTrack(track):
	selectMark = []
	var i = 1
	var opt = get_node(track + str(i))
	if not opt:
		return
	while opt:
		if not opt is AnimatedSprite2D or opt.sprite_frames:
			selectMark.append(opt)
		i += 1
		opt = get_node(track + str(i))
	
	selectTrack = track
