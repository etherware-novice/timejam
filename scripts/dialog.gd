extends CanvasLayer

var lastSpeaker
var dialogIndex
var nlines = 0

signal ended

func _ready():
	$name.visible_characters = 0
	$message.visible_characters = 0

func start(dialogArray):
	$AnimationPlayer.play("expand")
	await $AnimationPlayer.animation_finished
	dialogIndex = dialogArray
	
	var message = dialogIndex.keys()[0]
	$message.visible_characters = 0
	$message.text = message

	var speaker = dialogIndex[message]
	$name.visible_characters = 0
	$name.text = speaker
	lastSpeaker = speaker
	
	updatePortrait(speaker)
	$ticker.start()
	_on_ticker_timeout()


func _on_ticker_timeout():
	if $message.visible_ratio <= 3:
		$message.visible_characters += 1
	if $name.visible_ratio <= 3:
		$name.visible_characters += 1

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if dialogIndex != null && $message.visible_characters > 1:
			nlines += 1
			if nlines >= dialogIndex.size():
				dialogIndex = null
				ended.emit()
				$ticker.stop()
				$message.queue_free()
				$name.queue_free()
				$AnimatedSprite2D.queue_free()
				$AnimationPlayer.play_backwards("expand")
				$AnimationPlayer.animation_finished.connect(func(_a): queue_free())
				return
			var message = dialogIndex.keys()[nlines]
			$message.visible_characters = 0
			$message.text = message
			
			var speaker = dialogIndex[message]
			if speaker != lastSpeaker:
				$name.visible_characters = 0
				$name.text = speaker
				lastSpeaker = speaker
			updatePortrait(speaker)

func updatePortrait(speaker):
	if speaker == "123":
		$AnimatedSprite2D.scale = Vector2(1, 1)
	else:
		$AnimatedSprite2D.scale = Vector2(8, 8)
	$AnimatedSprite2D.play(speaker)
