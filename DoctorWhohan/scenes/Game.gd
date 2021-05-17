extends Node


export (PackedScene) var Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyTimer_timeout():
	$EnemyPath/PathFollow2D.offset = 100
	
	#Spawn patient
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = $EnemyPath/PathFollow2D.position
	enemy.linear_velocity = Vector2(-50,0)
	
	
	

#Function die Aufgerufen wird, wenn Patient die hitbox des Doktors trifft
func _on_Player_hit():
	$Player.hide()
