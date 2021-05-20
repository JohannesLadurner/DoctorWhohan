extends RigidBody2D


export var min_speed = 150  # min speed
export var max_speed = 250  # max speed
var animation_name

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	play_random_animation()
	

# Wenn Bildschirm verlassen wird
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_random_animation():
	var animations = $Need.frames.get_animation_names()
	var animation_id = randi() % animations.size()
	animation_name = animations[animation_id]
	$Need.play(animation_name)
	
	
	
