extends Node

export (PackedScene) var Enemy

var score #Punktestand
var start = false
var gamePaused = false
var pauseCoolDown = 0

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
var buyLifeCosts = 100
var upgradeCostsFactor = 1.5
var upgradeSpeedBy = 0.5

var bloodLevel = 1
var pillLevel = 1
var vaccineLevel = 1
var maskLevel = 1
var testLevel = 1

########ENEMY##########
var enemies = [] #Enemys die gespawnt sind
var enemyBaseSpeed = 50

########ROUND#########
var newRoundBeginning = true
var roundAnimReverse = false
var roundNr = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.play()
	hideStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = str(score)
	if start == true:
		checkPlayerInput()
		checkLife()
		checkEnemyTreated()
		updateUpgradeIcons()
		updateMoney()
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
	$HUD.show_game_over(score)
	backToStart()


#Funktion, die Anzahl der Leben überprüft 
func checkLife():
	if $Player.lifes == 3:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.show()
		$LifeFour.hide()
		$LifeFive.hide()
	elif $Player.lifes == 2:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.hide()
		$LifeFour.hide()
		$LifeFive.hide()
	elif $Player.lifes == 1:
		$LifeOne.show()
		$LifeTwo.hide()
		$LifeThree.hide()
		$LifeFour.hide()
		$LifeFive.hide()
	elif $Player.lifes == 4:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.show()
		$LifeFour.show()
		$LifeFive.hide()
	elif $Player.lifes == 5:
		$LifeOne.show()
		$LifeTwo.show()
		$LifeThree.show()
		$LifeFour.show()
		$LifeFive.show()
	else:
		$LifeOne.hide()
		$LifeTwo.hide()
		$LifeThree.hide()
		$LifeFour.hide()
		$LifeFive.hide()
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
	if !gamePaused:
		if $Player.isIdleing() == true:
			if Input.is_action_pressed("q") && $Player.unlockedNeeds.find("Blood") > -1:
				$Player.playBloodAnim()
			if Input.is_action_pressed("w") && $Player.unlockedNeeds.find("Mask") > -1:
				$Player.playMaskAnim()
			if Input.is_action_pressed("e") && $Player.unlockedNeeds.find("Pill") > -1:
				$Player.playPillAnim()
			if Input.is_action_pressed("r") && $Player.unlockedNeeds.find("Test") > -1:
				$Player.playTestAnim()
			if Input.is_action_pressed("t") && $Player.unlockedNeeds.find("Vaccine") > -1:
				$Player.playVaccineAnim()
			
		if Input.is_action_pressed("1"):
			if $UpgradeBlood.animation == "Available":
				$Player.bloodSpeed = $Player.bloodSpeed + upgradeSpeedBy
				$Player.updateAnimationSpeeds()
				$UpgradeBlood.play("Upgrade")
				$Player.money = $Player.money - upgradeBloodCosts
				bloodLevel = bloodLevel + 1
				$LevelBloodText.text = bloodLevel as String
				upgradeBloodCosts = (upgradeBloodCosts * upgradeCostsFactor) as int
				$UpgradeBloodText.text = "$"+upgradeBloodCosts as String
		if Input.is_action_pressed("2"):
			if $UpgradeMask.animation == "Available":
				$Player.maskSpeed = $Player.maskSpeed + upgradeSpeedBy
				$Player.updateAnimationSpeeds()
				$UpgradeMask.play("Upgrade")
				$Player.money = $Player.money - upgradeMaskCosts
				maskLevel = maskLevel + 1
				$LevelMaskText.text = maskLevel as String
				upgradeMaskCosts = (upgradeMaskCosts * upgradeCostsFactor) as int
				$UpgradeMaskText.text = "$"+upgradeMaskCosts as String
		if Input.is_action_pressed("3"):
			if $UpgradePill.animation == "Available":
				$Player.pillSpeed = $Player.pillSpeed + upgradeSpeedBy
				$Player.updateAnimationSpeeds()
				$UpgradePill.play("Upgrade")
				$Player.money = $Player.money - upgradePillCosts
				pillLevel = pillLevel + 1
				$LevelPillText.text = pillLevel as String
				upgradePillCosts = (upgradePillCosts * upgradeCostsFactor) as int
				$UpgradePillText.text = "$"+upgradePillCosts as String
		if Input.is_action_pressed("4"):
			if $UpgradeTest.animation == "Available":
				$Player.testSpeed = $Player.testSpeed + upgradeSpeedBy
				$Player.updateAnimationSpeeds()
				$UpgradeTest.play("Upgrade")
				$Player.money = $Player.money - upgradeTestCosts
				testLevel = testLevel + 1
				$LevelTestText.text = testLevel as String
				upgradeTestCosts = (upgradeTestCosts * upgradeCostsFactor) as int
				$UpgradeTestText.text = "$"+upgradeTestCosts as String
		if Input.is_action_pressed("5"):
			if $UpgradeVaccine.animation == "Available":
				$Player.vaccineSpeed = $Player.vaccineSpeed + upgradeSpeedBy
				$Player.updateAnimationSpeeds()
				$UpgradeVaccine.play("Upgrade")
				$Player.money = $Player.money - upgradeMaskCosts
				vaccineLevel = vaccineLevel + 1
				$LevelVaccineText.text = vaccineLevel as String
				upgradeVaccineCosts = (upgradeVaccineCosts * upgradeCostsFactor) as int
				$UpgradeVaccineText.text = "$"+upgradeVaccineCosts as String
		if Input.is_action_pressed("6"):
			if $BuyLife.animation == "Available":
				$Player.lifes = $Player.lifes + 1
				$BuyLife.play("Buy")
				$Player.money = $Player.money - buyLifeCosts
				buyLifeCosts = (buyLifeCosts * upgradeCostsFactor) as int
				$BuyLifeText.text = "$"+buyLifeCosts as String
	
	if Input.is_action_pressed("Space"):
		if pauseCoolDown > 0:
			return null
		pauseCoolDown = 20
		gamePaused = !gamePaused
		if gamePaused == true:
			$EnemyTimer.paused = true
			$RoundTimer.paused = true
			$Paused.show()
			for i in enemies.size():
				enemies[i].linear_velocity = Vector2(0,0)
				enemies[i].setIdle()
		else:
			$EnemyTimer.paused = false
			$RoundTimer.paused = false
			$Paused.hide()
			for i in enemies.size():
				enemies[i].linear_velocity = Vector2(-enemies[i].speed,0)
				enemies[i].setPlay()
	
	pauseCoolDown = pauseCoolDown - 1

func checkEnemyTreated():
	if enemies.size() != 0:
		for i in enemies.size():
			if enemies[i].isInside == true && enemies[i].gotTreated == false && enemies[i].needName == $Player/AnimatedSprite.animation:
				enemies[i].gotTreated = true
				if enemies[i].needName == "Mask":
					enemies[i].putOnMask()
				$Player.money = $Player.money + 20

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

func updateMoney():
	var currMoney = $Money.text.substr(8, -1) as int
	if currMoney < $Player.money:
		if currMoney + 20 >= $Player.money:
			currMoney = currMoney + 1
		else:
			currMoney = currMoney + ((($Player.money - currMoney) * 5) / 100) #Plus 2% of the difference
		$Money.text = "Money: $" + currMoney as String
	if currMoney > $Player.money:
		if currMoney - 20 <= $Player.money:
			currMoney = currMoney - 1
		else:
			currMoney = currMoney - (((currMoney - $Player.money) * 5) / 100) #Minus 2% of the difference
		$Money.text = "Money: $" + currMoney as String
	
func updateUpgradeIcons():
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
	#Buy Life
	if $Player.lifes < 5:
		if $Player.money >= buyLifeCosts:
			if $BuyLife.animation == "Unavailable":
				$BuyLife.play("Available")
			$BuyLifeText.add_color_override("font_color", Color(0, 1, 0, 1)) #Green
		if $Player.money < buyLifeCosts:
			if $BuyLife.animation == "Available":
				$BuyLife.play("Unavailable")
			$BuyLifeText.add_color_override("font_color", Color(1, 0, 0, 1)) #Red
	else:
		if $BuyLife.animation == "Available":
			$BuyLife.play("Unavailable")
			$BuyLifeText.add_color_override("font_color", Color8(100, 100, 100, 255)) #Red
			
	
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

func _on_BuyLife_animation_finished():
	if $BuyLife.animation == "Buy":
		$BuyLife.play("Available")
	pass
	
#############################################
###################HUD######################
#############################################

#Calls when the start button is pressed
func _on_HUD_start_game():
	start = true
	$HUD.hideAll()
	showAll()
	randomize()
	$LifeOne.play()
	$LifeTwo.play()
	$LifeThree.play()
	$LifeFour.play()
	$LifeFive.play()
	$UpgradeBlood.play("Locked")
	$UpgradeMask.play("Locked")
	$UpgradePill.play("Locked")
	$UpgradeTest.play("Locked")
	$UpgradeVaccine.play("Locked")
	$BuyLife.play("Available")
	score = 0
	$Player.lifes = 3
	
	
#hide all things
func hideStart():
	$LifeOne.hide()
	$LifeTwo.hide()
	$LifeThree.hide()
	$LifeFour.hide()
	$LifeFive.hide()
	$RoundTitle.hide()
	$RoundNumLeft.hide()
	$RoundNumRight.hide()
	$UpgradeBlood.hide()
	$UpgradeBloodText.hide()
	$UpgradeMask.hide()
	$UpgradeMaskText.hide()
	$UpgradePill.hide()
	$UpgradePillText.hide()
	$UpgradeTest.hide()
	$UpgradeTestText.hide()
	$UpgradeVaccine.hide()
	$UpgradeVaccineText.hide()
	$BuyLife.hide()
	$BuyLifeText.hide()
	$Money.hide()
	$EffectDescription.hide()
	$LevelBloodText.hide()
	$LevelMaskText.hide()
	$LevelPillText.hide()
	$LevelTestText.hide()
	$LevelVaccineText.hide()
	$Score.hide()
	$Paused.hide()
	
	
#show all things
func showAll():
	$LifeOne.show()
	$LifeTwo.show()
	$LifeThree.show()
	$RoundTitle.show()
	$RoundNumLeft.show()
	$RoundNumRight.show()
	$UpgradeBlood.show()
	$UpgradeBloodText.show()
	$UpgradeMask.show()
	$UpgradeMaskText.show()
	$UpgradePill.show()
	$UpgradePillText.show()
	$UpgradeTest.show()
	$UpgradeTestText.show()
	$UpgradeVaccine.show()
	$UpgradeVaccineText.show()
	$BuyLife.show()
	$BuyLifeText.show()
	$LevelBloodText.show()
	$LevelMaskText.show()
	$LevelPillText.show()
	$LevelTestText.show()
	$LevelVaccineText.show()
	$Money.show()
	$EffectDescription.show()
	$Score.show()

func backToStart():
	get_tree().reload_current_scene()
	



