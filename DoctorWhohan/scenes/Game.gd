extends Node

export (PackedScene) var Enemy

var score #Punktestand

########NEEDS#########
enum needType{
	Blood,
	Pill,
	Vaccine,
	Mask,
	Empty,
	Test
}
var upgradeBloodCosts = 100
var upgradePillCosts = 100
var upgradeVaccineCosts = 100
var upgradeMaskCosts = 100
var upgradeTestCosts = 100
var upgradeCostsFactor = 1.5
var upgradeSpeedBy = 0.5

########ENEMY##########
var enemies = [] #Enemys die gespawnt sind
var enemyBaseSpeed = 50

########ROUND#########
var newRoundBeginning = true
var roundAnimReverse = false
var roundNr = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$LifeOne.play()
	$LifeTwo.play()
	$LifeThree.play()
	$UpgradeBlood.play("Locked")
	$UpgradeMask.play("Locked")
	$UpgradePill.play("Locked")
	$UpgradeTest.play("Locked")
	$UpgradeVaccine.play("Locked")
	score = 0
	$Player.lifes = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = str(score)
	checkLife()
	checkPlayerInput()
	checkEnemyTreated()
	updateUpgradeIcons()
	if newRoundBeginning == true && enemies.size() == 0: #Start new round when all enemies are gone
		initNewRound()
		newRoundBeginning = false


func _on_EnemyTimer_timeout():
	$EnemyPath/PathFollow2D.offset = 100

	#Spawn patient
	var enemy = Enemy.instance()
	enemy.init($Player.unlockedNeeds)
	add_child(enemy)
	enemy.position = $EnemyPath/PathFollow2D.position
	enemy.speed = (randi() % enemyBaseSpeed) + enemyBaseSpeed #min speed = baseSpeed, max speed = 2*baseSpeed
	enemy.linear_velocity = Vector2(-enemy.speed,0)
	enemies.append(enemy)


#Function die Aufgerufen wird, wenn Patient die hitbox des Doktors trifft
func _on_Player_hit():
	$Player.enteredBody.isInside = true
	


#Wird aufgerufen, wenn alle Leben verbraucht sind
func gameOver():
	$Player.hide()
	pass


#Funktion, die Anzahl der Leben überprüft 
func checkLife():
	if $Player.lifes == 3:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.show()
	elif $Player.lifes == 2:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.hide()
	elif $Player.lifes == 1:
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
		$Player.lifes = $Player.lifes - 1
	else:
		score = score +1
	enemies.erase(current)


#Überprüft ob etwas beim Player ist und ob der richtige Button gedrückt wurde
func checkPlayerInput():
	if $Player.isIdleing() == true:
		if Input.is_action_pressed("w") && $Player.unlockedNeeds.find("Blood") > -1:
			$Player.playBloodAnim()
		if Input.is_action_pressed("q") && $Player.unlockedNeeds.find("Mask") > -1:
			$Player.playMaskAnim()
		if Input.is_action_pressed("e") && $Player.unlockedNeeds.find("Pill") > -1:
			$Player.playPillAnim()
		if Input.is_action_pressed("r") && $Player.unlockedNeeds.find("Test") > -1:
			$Player.playTestAnim()
		if Input.is_action_pressed("a") && $Player.unlockedNeeds.find("Vaccine") > -1:
			$Player.playVaccineAnim()
			
	if Input.is_action_pressed("1"):
		if $UpgradeBlood.animation == "Available":
			$Player.bloodSpeed = $Player.bloodSpeed + upgradeSpeedBy
			$Player.updateAnimationSpeeds()
			$UpgradeBlood.play("Upgrade")
			$Player.money = $Player.money - upgradeBloodCosts
			upgradeBloodCosts = (upgradeBloodCosts * upgradeCostsFactor) as int
			$UpgradeBloodText.text = "$"+upgradeBloodCosts as String
	if Input.is_action_pressed("2"):
		if $UpgradeMask.animation == "Available":
			$Player.maskSpeed = $Player.maskSpeed + upgradeSpeedBy
			$Player.updateAnimationSpeeds()
			$UpgradeMask.play("Upgrade")
			$Player.money = $Player.money - upgradeMaskCosts
			upgradeMaskCosts = (upgradeMaskCosts * upgradeCostsFactor) as int
			$UpgradeMaskText.text = "$"+upgradeMaskCosts as String
	if Input.is_action_pressed("3"):
		if $UpgradePill.animation == "Available":
			$Player.pillSpeed = $Player.pillSpeed + upgradeSpeedBy
			$Player.updateAnimationSpeeds()
			$UpgradePill.play("Upgrade")
			$Player.money = $Player.money - upgradePillCosts
			upgradePillCosts = (upgradePillCosts * upgradeCostsFactor) as int
			$UpgradePillText.text = "$"+upgradePillCosts as String
	if Input.is_action_pressed("4"):
		if $UpgradeTest.animation == "Available":
			$Player.testSpeed = $Player.testSpeed + upgradeSpeedBy
			$Player.updateAnimationSpeeds()
			$UpgradeTest.play("Upgrade")
			$Player.money = $Player.money - upgradeTestCosts
			upgradeTestCosts = (upgradeTestCosts * upgradeCostsFactor) as int
			$UpgradeTestText.text = "$"+upgradeTestCosts as String
	if Input.is_action_pressed("5"):
		if $UpgradeVaccine.animation == "Available":
			$Player.vaccineSpeed = $Player.vaccineSpeed + upgradeSpeedBy
			$Player.updateAnimationSpeeds()
			$UpgradeVaccine.play("Upgrade")
			$Player.money = $Player.money - upgradeMaskCosts
			upgradeVaccineCosts = (upgradeVaccineCosts * upgradeCostsFactor) as int
			$UpgradeVaccineText.text = "$"+upgradeVaccineCosts as String

func checkEnemyTreated():
	if enemies.size() != 0:
		for i in enemies.size():
			if enemies[i].isInside == true && enemies[i].gotTreated == false && enemies[i].needName == $Player/AnimatedSprite.animation:
				enemies[i].gotTreated = true
				$Player.money = $Player.money + 10

func addRandomNeed():
	var allNeedTypes = needType.keys()
	allNeedTypes.shuffle()
	if $Player.unlockedNeeds.size() < allNeedTypes.size() - 1: #never add the empty type, if list is complete ignore function
		var index = 0
		#add only to list if it is not already in + not the empty type
		while ($Player.unlockedNeeds.find(allNeedTypes[index]) > -1) || (allNeedTypes[index] == needType.keys()[needType.Empty]):
			index = index + 1
			
		$Player.unlockedNeeds.append(allNeedTypes[index])
		if(allNeedTypes[index] == "Blood"):
			$UpgradeBlood.play("Unavailable")
		if(allNeedTypes[index] == "Pill"):
			$UpgradePill.play("Unavailable")
		if(allNeedTypes[index] == "Mask"):
			$UpgradeMask.play("Unavailable")
		if(allNeedTypes[index] == "Vaccine"):
			$UpgradeVaccine.play("Unavailable")
		if(allNeedTypes[index] == "Test"):
			$UpgradeTest.play("Unavailable")
		return allNeedTypes[index]
	return null

func updateUpgradeIcons():
	$Money.text = "Money: $" + $Player.money as String
	#Update Blood
	if $UpgradeBlood.animation != "Locked":
		if $Player.money >= upgradeBloodCosts:
			if $UpgradeBlood.animation == "Unavailable":
				$UpgradeBlood.play("Available")
			$UpgradeBloodText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < upgradeBloodCosts:
			if $UpgradeBlood.animation == "Available":
				$UpgradeBlood.play("Unavailable")
			$UpgradeBloodText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red
	#Update Pill
	if $UpgradePill.animation != "Locked":
		if $Player.money >= upgradePillCosts:
			if  $UpgradePill.animation == "Unavailable":
				$UpgradePill.play("Available")
			$UpgradePillText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < upgradePillCosts:
			if $UpgradePill.animation == "Available":
				$UpgradePill.play("Unavailable")
			$UpgradePillText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red
	#Update Vaccine
	if $UpgradeVaccine.animation != "Locked":
		if $Player.money >= upgradeVaccineCosts:
			if $UpgradeVaccine.animation == "Unavailable":
				$UpgradeVaccine.play("Available")
			$UpgradeVaccineText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < upgradeVaccineCosts:
			if $UpgradeVaccine.animation == "Available":
				$UpgradeVaccine.play("Unavailable")
			$UpgradeVaccineText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red
	#Update Mask
	if $UpgradeMask.animation != "Locked":
		if $Player.money >= upgradeMaskCosts:
			if $UpgradeMask.animation == "Unavailable":
				$UpgradeMask.play("Available")
			$UpgradeMaskText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < upgradeMaskCosts:
			if $UpgradeMask.animation == "Available":
				$UpgradeMask.play("Unavailable")
			$UpgradeMaskText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red
	#Update Test
	if $UpgradeTest.animation != "Locked":
		if $Player.money >= upgradeTestCosts:
			if $UpgradeTest.animation == "Unavailable":
				$UpgradeTest.play("Available")
			$UpgradeTestText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < upgradeTestCosts:
			if $UpgradeTest.animation == "Available":
				$UpgradeTest.play("Unavailable")
			$UpgradeTestText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red


#############################################
############Rounds###########################
#############################################

func initNewRound():
	roundNr = roundNr + 1
	playRoundAnimation(roundNr, false)
	if roundNr == 1: #first round begin with a need
		var effectName = addRandomNeed()
		$EffectDescription.text = "New Effect: " + effectName
	else:
		addNewRandomEffect()
	$EffectDescription.show()

func playRoundAnimation(roundNumber, reverse):
	var leftDigit = 0
	var rightDigit = 0
	if(roundNumber < 10):
		rightDigit = roundNumber
	else:
		leftDigit = (roundNumber / 10)
		rightDigit = roundNumber % 10

	$RoundTitle.play("Title", reverse) #play the animation
	$RoundNumLeft.play(leftDigit as String, reverse)
	$RoundNumRight.play(rightDigit as String, reverse)

func addNewRandomEffect():
	var effectChosen = false
	while effectChosen == false:
		var randomEffect = randi() % 3
		print(randomEffect)
		if randomEffect == 0: #Add a new need
			var effectName = addRandomNeed()
			if effectName != null:
				$EffectDescription.text = "New Effect: " + effectName
				effectChosen = true
		if randomEffect == 1: #Increase the speed of the patients
			enemyBaseSpeed = enemyBaseSpeed + 10
			$EffectDescription.text = "Patients Speed Increased"
			effectChosen = true
		if randomEffect == 2: #Faster patient spwaning
			if $EnemyTimer.wait_time - 0.1 > 0:
				$EnemyTimer.wait_time = $EnemyTimer.wait_time - 0.1
				$EffectDescription.text = "Patients Spawn Time Decreased"
				effectChosen = true


func _on_RoundTimer_timeout():
	$EnemyTimer.stop() #when a new Round starts, stop spawning enemies
	$RoundTimer.stop()
	newRoundBeginning = true


func _on_RoundTitle_animation_finished():
	if $RoundTitle.animation != "Empty":
		if roundAnimReverse == false: #when animation is finished, play it in reverse
			playRoundAnimation(roundNr, true)
			roundAnimReverse = true
		else: #animation is finished in reverse, start with new round
			$EnemyTimer.start() #As soon as the animation finished, start round Time again and spawn enemies
			$RoundTimer.start()
			$RoundTitle.play("Empty") #reset the animation, stop() does not work?
			$RoundNumLeft.play("Empty")
			$RoundNumRight.play("Empty")
			$EffectDescription.hide()
			roundAnimReverse = false

#############################################
############Upgrade animations###############
#############################################

func _on_UpgradeBlood_animation_finished():
	if $UpgradeBlood.animation == "Upgrade":
		$UpgradeBlood.play("Available")
	pass

func _on_UpgradeMask_animation_finished():
	if $UpgradeMask.animation == "Upgrade":
		$UpgradeMask.play("Available")
	pass
	

func _on_UpgradePill_animation_finished():
	if $UpgradePill.animation == "Upgrade":
		$UpgradePill.play("Available")
	pass

func _on_UpgradeTest_animation_finished():
	if $UpgradeTest.animation == "Upgrade":
		$UpgradeTest.play("Available")
	pass

func _on_UpgradeVaccine_animation_finished():
	if $UpgradeVaccine.animation == "Upgrade":
		$UpgradeVaccine.play("Available")
	pass
