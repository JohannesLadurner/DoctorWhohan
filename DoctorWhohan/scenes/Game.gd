extends Node


export (PackedScene) var Enemy
var score #Punktestand
var life  #Leben 
var enemys = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyTimer.start()
	score = 0
	life = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = str(score)
	checkLife()
	print(enemys.size())
	



func _on_EnemyTimer_timeout():
	$EnemyPath/PathFollow2D.offset = 100
	
	#Spawn patient
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = $EnemyPath/PathFollow2D.position
	enemy.linear_velocity = Vector2(-100,0)
	enemys.append(enemy)
	

#Function die Aufgerufen wird, wenn Patient die hitbox des Doktors trifft
func _on_Player_hit():
	score = score +1
	life = life -1
	var current = enemys[0]
	current.hide()
	enemys.erase(current)
	
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
