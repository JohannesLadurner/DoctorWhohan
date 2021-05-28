extends RigidBody2D


export var min_speed = 150  # min speed
export var max_speed = 250  # max speed
var stillNeeding = false
var needName
var isInside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#play_random_animation()
	
func init(unlockedNeeds):
	var rndNeed = randi() % unlockedNeeds.size()
	needName = unlockedNeeds[rndNeed]
	$Need.play(needName)
	$AnimatedSprite.play("MManMaskWalk")
	
# Wenn Bildschirm verlassen wird
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
	
	
