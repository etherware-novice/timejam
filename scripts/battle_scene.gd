extends Node2D

var playerMove = false
var selectIndex = 0
# select track basically controls which things you can select (enemies, menu opts, etc)
var selectMark = []
var selectTrack : set = _setSelectTrack
var subMenu
var mainMenuText = ["Fight", "Special", "Heal", "Run"]

var turnOrder = []
var subTurn = 99  # turn order index, set so high so the player always starts
var turnCount = 0
var nextInput = null

var nextBattleId = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$battleCam.make_current()
#	var bsize = $player.scale * 2  # this is to keep the colorrect about the same size as the player
#	$paddlectrl/ball.size = bsize
	
	var i = 1
	for x in constants.senarioLookup[nextBattleId]:
		var charBase = constants.charLookup[x]
		var spr = get_node("enemy" + str(i))
		spr.script = load(charBase + ".gd")
		spr._ready()  # maybe a bad idea but it worky
		spr.set_process(true)
		spr.get_node("AnimatedSprite2D").sprite_frames = load(charBase + ".tres")
		spr.get_node("AnimatedSprite2D").play()
		spr.connect("endTurn", nextTurn)
		spr.connect("updateHp", $VHSLine.updateHP)
		turnOrder.append(spr)
		
		i += 1
	nextTurn()


func nextTurn():
	subTurn += 1
	if subTurn >= turnOrder.size():
		playerMove = true
		selectTrack = "main"
		subMenu = "main"
		subTurn = -1  # to offset the +1
		return
	
	playerMove = false
	selectTrack = "disable"
	_unhandled_key_input(null)
	
	#turnOrder[subTurn].doAttack($player)
	if turnOrder[subTurn].canAttack:
		$paddlectrl.start()
	else:
		nextTurn()


func _unhandled_key_input(event):
	if selectTrack == "disable":
		$selector.position = Vector2(-999,-999)
		return
	
	if event.is_action_pressed("ui_accept"):
		if selectTrack == "main":
			match selectIndex:
				0:
					selectTrack = "enemy"
					subMenu = "attack"
		elif subMenu == "attack":
			playerDoAttack()
			return
		selectIndex=0
	
	if event.is_action_pressed("ui_cancel"):
		selectTrack = "main"
		subMenu = "main"
		
	if selectMark.size() > 1:
		if event.is_action_pressed("ui_left",true):
			selectIndex -= 1
			$VHSControl/flipper.play("flip")
			$VHSControl/flipperText.text = ""
		elif event.is_action_pressed("ui_right",true):
			selectIndex += 1
			$VHSControl/flipper.play("flip")
			$VHSControl/flipperText.text = ""
			
	selectIndex = clamp(selectIndex, 0, max(selectMark.size() - 1, 0) )
	
	$selector.position = selectMark[selectIndex].position + Vector2(0, -50)
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
	$selector.position = opt.position + Vector2(0, -50)
	while opt:
		if not opt is enemy or opt.targetable:
			selectMark.append(opt)
		i += 1
		opt = get_node(track + str(i))
	
	selectTrack = track

func playerDoAttack():
	var target = selectMark[selectIndex]
	selectTrack = "disable"
	
	var sprite = $player/AnimatedSprite2D
	sprite.play("attackMain")
	while sprite.frame < 6:
		await sprite.frame_changed
	if not Input.is_action_pressed("ui_accept"):  # no cheating by holding the button
		while sprite.frame < 12:
			if Input.is_action_pressed("ui_accept"):
				sprite.play("attackHit")
				await doBallThrow($player.position, target.position)
				target.recDmg(5)
				print("action command success")
				break
			await sprite.frame_changed
	
	if sprite.is_playing():
		await sprite.animation_finished
	sprite.play("attackMain")
	sprite.stop()
	nextTurn()
	
func doBallThrow(start, end):
	var tweener := create_tween()
	$paddlectrl/ball.position = start
	tweener.tween_property($paddlectrl/ball, "position", end, 0.2)
	await tweener.finished
	$paddlectrl/ball.position = Vector2(-999, -999)


func _on_paddlectrl_finished():
	nextTurn()


func _on_flipper_animation_finished():
	if subMenu != "main":
		return
	$VHSControl/flipperText.text = mainMenuText[selectIndex]
