extends Area2D


signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	 var screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_body_entered(body):
	emit_signal("hit")
	
