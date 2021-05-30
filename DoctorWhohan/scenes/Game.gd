extends Node

export (PackedScene) var Enemy
var score #Punktestand
var life  #Leben 
var enemies = [] #Enemys die gespawnt sind
var unlockedNeeds = []

enum needType{
	Blood,
	Pill,
	Vaccine,
	Mask,
	Empty,
	Test
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	addRandomNeed()
	#unlockedNeeds.append(allNeedTypes[needType.Vaccine])
	$EnemyTimer.start()
	$LifeOne.play()
	$LifeTwo.play()
	$LifeThree.play()
	playRoundAnimation(65)
	
	score = 0
	life = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = str(score)
	checkLife()
	checkPlayerInput()
	checkEnemyTreated()
	
	

func _on_EnemyTimer_timeout():
	$EnemyPath/PathFollow2D.offset = 100
	#addRandomNeed()
	
	#Spawn patient
	var enemy = Enemy.instance()
	enemy.init(unlockedNeeds)
	add_child(enemy)
	enemy.position = $EnemyPath/PathFollow2D.position
	enemy.linear_velocity = Vector2(-100,0)
	enemies.append(enemy)
	

#Function die Aufgerufen wird, wenn Patient die hitbox des Doktors trifft
func _on_Player_hit():
	$Player.enteredBody.isInside = true
	
	
#Wird aufgerufen, wenn alle Leben verbraucht sind
func gameOver():
	$Player.hide()
	
#Funktion, die Anzahl der Leben überprüft 
func checkLife():
	if life == 3:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.show()
	elif life == 2:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.hide()
	elif life == 1:
		$LifeOne.show()
		$LifeTwo.hide()
		$LifeThree.hide()
	else:
		$LifeOne.hide()
		$LifeTwo.hide()
		$LifeThree.hide()
		gameOver()

#Wird aufgerufen, wenn der Player verlassen wird
func _on_Player_exit():
	$Player.enteredBody.isInside = false
	var current = enemies[0]
	if current.gotTreated == false:
		life = life - 1
	else:
		score = score +1
	enemies.erase(current)

#Überprüft ob etwas beim Player ist und ob der richtige Button gedrückt wurde
func checkPlayerInput():
	if($Player.isIdleing() == true):
		if Input.is_action_pressed("w"):
			$Player.playBloodAnim()
		if Input.is_action_pressed("q"):
			$Player.playMaskAnim()
		if Input.is_action_pressed("e"):
			$Player.playPillAnim()
		if Input.is_action_pressed("r"):
			$Player.playTestAnim()
		if Input.is_action_pressed("a"):
			$Player.playVaccineAnim()
		
func checkEnemyTreated():
	if enemies.size() != 0:
		for i in enemies.size():
			if enemies[i].isInside == true && enemies[i].needName == $Player/AnimatedSprite.animation:
				enemies[i].gotTreated = true
				
func addRandomNeed():
	var allNeedTypes = needType.keys()
	allNeedTypes.shuffle()
	if unlockedNeeds.size() < allNeedTypes.size() - 1: #never add the empty type, if list is complete ignore function
		var index = 0
		#add only to list if it is not already in + not the empty type
		while (unlockedNeeds.find(allNeedTypes[index]) > -1) || (allNeedTypes[index] == needType.keys()[needType.Empty]):
			index = index + 1
			
		unlockedNeeds.append(allNeedTypes[index])
		
func playRoundAnimation(roundNumber):
	var leftDigit = 0
	var rightDigit = 0
	if(roundNumber < 10):
		leftDigit = roundNumber
	else:
		leftDigit = (roundNumber / 10)
		rightDigit = roundNumber % 10
	
	$RoundTitle.play()
	$RoundNumLeft.play(leftDigit as String)
	$RoundNumRight.play(rightDigit as String)
		
