extends RigidBody2D


export var min_speed = 150  # min speed
export var max_speed = 250  # max speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Wenn Bildschirm verlassen wird
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
