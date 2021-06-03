extends CanvasLayer

signal start_game



func _ready():
	pass # Replace with function body.



#func _process(delta):
#	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(score):
	show_message("GAME OVER")
	$ColorRect.show()
	$ScoreMsg.show()
	$Score.text = str(score)
	$Score.show()
	yield($MessageTimer, "timeout")

	$Message.text = "DOCTOR WHOHAN"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	

func update_score(score):
	$Score.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_Start_pressed():
	emit_signal("start_game")
	
func hideAll():
	$ColorRect.hide()
	$Start.hide()
	$Message.hide()
	$ScoreMsg.hide()
	$Score.hide()
	

