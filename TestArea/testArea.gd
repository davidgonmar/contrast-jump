extends Node


onready var player = $playerBody


onready var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()



func _ready():
	player.connect("enemyHit", self, "playerEnemyHit")
	addEnemy()
	
	
func playerEnemyHit():
	print("hit an enemy!")
	player.die()


func _on_reloadButton_pressed():
	fadeInOutBackground.initiateMode("inOut")
	yield (fadeInOutBackground, "halfAnimationCompleted")
	get_tree().reload_current_scene()
	
	
	
func addEnemy():
	ring.desiredRadius = 300
	add_child(ring)
