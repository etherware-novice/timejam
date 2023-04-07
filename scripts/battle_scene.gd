extends Node2D

var playerMove = false
var selectIndex = 0
# select track basically controls which things you can select (enemies, menu opts, etc)
var selectMark = []
var selectTrack : set = _setSelectTrack
var subMenu

var turnOrder = []
var subTurn = 99  # turn order index, set so high so the player always starts
var turnCount = 0
var nextInput = null

var nextBattleId = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$battleCam.make_current()
	var bsize = $player.scale * 2  # this is to keep the colorrect about the same size as the player
	$ball.size = bsize
	
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
	subTurn += 1
	if subTurn >= turnOrder.size():
		playerMove = true
		selectTrack = "main"
		subTurn = -1  # to offset the +1
		return
	
	playerMove = false
	selectTrack = "disable"
	_unhandled_key_input(null)
	
	turnOrder[subTurn].doAttack($player)


func _unhandled_key_input(event):
	if selectTrack == "disable":
		$selector.position = Vector2(-999,-999)
		return
	
	if event.is_action_pressed("ui_accept"):
		if selectTrack == "main":
			match selectIndex:
				0:
					selectTrack = "enemy"
		elif selectTrack == "enemy":
			playerDoAttack()
			return
		selectIndex=0
		
	if selectMark.size() > 1:
		if event.is_action_pressed("ui_left",true):
			selectIndex -= 1
		elif event.is_action_pressed("ui_right",true):
			selectIndex += 1
		
	selectIndex = clamp(selectIndex, 0, max(selectMark.size() - 1, 0) )
	
	$selector.position = selectMark[selectIndex].position
	pass

func _setSelectTrack(track):
	selectMark = []
	if track == "disable":
		selectTrack = track
		return
	var i = 1
	var opt = get_node(track + str(i))
	if not opt:
		return
	$selector.position = opt.position
	while opt:
		if not opt is enemy or opt.targetable:
			selectMark.append(opt)
		i += 1
		opt = get_node(track + str(i))
	
	selectTrack = track

func playerDoAttack():
	var target = selectMark[selectIndex]
	selectTrack = "disable"
	$player.play("attackMain")
	while $player.frame < 6:
		await $player.frame_changed
	if not Input.is_action_pressed("ui_accept"):  # no cheating by holding the button
		while $player.frame < 12:
			if Input.is_action_pressed("ui_accept"):
				$player.play("attackHit")
				await doBallThrow($player.position, target.position)
				target.recDmg(5)
				print("action command success")
				break
			await $player.frame_changed
	
	if $player.is_playing():
		await $player.animation_finished
	$player.play("attackMain")
	$player.stop()
	nextTurn()
	
func doBallThrow(start, end):
	var tweener := create_tween()
	$ball.position = start
	tweener.tween_property($ball, "position", end, 0.2)
	await tweener.finished
	$ball.position = Vector2(-999, -999)
