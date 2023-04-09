extends CanvasLayer

var lastSpeaker
var dialogIndex
var nlines = 0

func _ready():
	$name.visible_characters = 0
	$message.visible_characters = 0

func start(dialogArray):
	$AnimationPlayer.play("expand")
	await $AnimationPlayer.animation_finished
	dialogIndex = dialogArray
	var tweener = create_tween()
	$ticker.start()
	_on_ticker_timeout()


func _on_ticker_timeout():
	if $message.visible_ratio <= 3:
		$message.visible_characters += 1
	if $name.visible_ratio <= 3:
		$name.visible_characters += 1

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if dialogIndex != null:
			nlines += 1
			if nlines >= dialogIndex.size():
				dialogIndex = null
				$ticker.stop()
				$message.queue_free()
				$name.queue_free()
				$AnimationPlayer.play_backwards("expand")
				$AnimationPlayer.animation_finished.connect(func(): queue_free())
				return
			var message = dialogIndex.keys()[nlines]
			$message.visible_characters = 0
			$message.text = message
			
			var speaker = dialogIndex[message]
			if speaker != lastSpeaker:
				$name.visible_characters = 0
				$name.text = speaker
				lastSpeaker = speaker
