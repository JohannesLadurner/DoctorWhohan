extends Area2D


signal hit
signal exit
var enteredBody
var isInside = false
var lifes  #Leben 
var money = 100
var unlockedNeeds = []
var bloodSpeed = 5.0
var maskSpeed = 5.0
var pillSpeed = 5.0
var testSpeed = 5.0
var vaccineSpeed = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	 var screen_size = get_viewport_rect().size
	 playIdleAnim()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_Player_body_entered(body):
	enteredBody = body
	emit_signal("hit")
	
func updateAnimationSpeeds():
	$AnimatedSprite.frames.set_animation_speed("Blood", bloodSpeed)
	$AnimatedSprite.frames.set_animation_speed("Mask", maskSpeed)
	$AnimatedSprite.frames.set_animation_speed("Pill", pillSpeed)
	$AnimatedSprite.frames.set_animation_speed("Test", testSpeed)
	$AnimatedSprite.frames.set_animation_speed("Vaccine", vaccineSpeed)

func _anim_finished():
	playIdleAnim()

func _on_Player_body_exited(body):
	emit_signal("exit")

func isIdleing():
	return $AnimatedSprite.animation == "Idle"

func playIdleAnim():
	 $AnimatedSprite.play("Idle")
	
func playBloodAnim():
	$AnimatedSprite.play("Blood")
	
func playPillAnim():
	$AnimatedSprite.play("Pill")

func playMaskAnim():
	$AnimatedSprite.play("Mask")
	
func playVaccineAnim():
	$AnimatedSprite.play("Vaccine")

func playTestAnim():
	$AnimatedSprite.play("Test")
