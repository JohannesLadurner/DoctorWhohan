extends CanvasLayer

signal start_game



func _ready():
	pass # Replace with function body.



#func _process(delta):
#	pass

func show_message(text):
	$ColorRect/Message.text = text
	$ColorRect/Message.show()
	$ColorRect/MessageTimer.start()

func show_game_over(score):
	show_message("GAME OVER")
	$ColorRect.show()
	$ColorRectInstruct.hide()
	yield($ColorRect/MessageTimer, "timeout")

	$ColorRect/Message.text = "DOCTOR WHOHAN"
	$ColorRect/Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$ColorRect/Start.show()
	$ColorRect/Instructions.show()
	


func _on_MessageTimer_timeout():
	$ColorRect/Message.hide()

func _on_Start_pressed():
	emit_signal("start_game")
	
func hideAll():
	$ColorRect.hide()
	
	
func _on_Button_pressed():
	$ColorRectInstruct.hide()
	$ColorRect.show()


func _on_Instructions_pressed():
	$ColorRectInstruct.show()
	$ColorRect.hide()
