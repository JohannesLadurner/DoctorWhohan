extends RigidBody2D


export var min_speed = 150  # min speed
export var max_speed = 250  # max speed
var gotTreated = false
var needName
var isInside = false
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
func init(unlockedNeeds):
	var rndNeed = randi() % unlockedNeeds.size()
	needName = unlockedNeeds[rndNeed]
	$Need.play(needName)
	
	var allCharacters = $AnimatedSprite.frames.get_animation_names()
	var rnd = randi() % allCharacters.size()
	var character = allCharacters[rnd]
	if needName == "Mask":
		while character.begins_with("Mask"): #Choose any character that does NOT wear a mask
			rnd = randi() % allCharacters.size()
			character = allCharacters[rnd]
	else:
		while !character.begins_with("Mask"): #Choose only characters that wears a mask
			rnd = randi() % allCharacters.size()
			character = allCharacters[rnd]
	
	$AnimatedSprite.play(character)

func putOnMask():
	var maskAnimation = "Mask" + $AnimatedSprite.animation
	$AnimatedSprite.play(maskAnimation)


# Wenn Bildschirm verlassen wird
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gotTreated == true:
		$Need.hide()
	
	
	
