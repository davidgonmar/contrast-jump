extends Node


var verticalMovingCircleGenerator = load("res://Enemies/VerticalMovingCircle/verticalMovingCircleGenerator.tscn").instance()
func _ready():
	setUpVMCircleGenerator()
	
	

func setUpVMCircleGenerator():
	add_child(verticalMovingCircleGenerator)
	verticalMovingCircleGenerator.isActive = true
	verticalMovingCircleGenerator.waitTime = 1.4
	verticalMovingCircleGenerator.numberOfEnemies = 3
	verticalMovingCircleGenerator.numberOfLayers = 6
	verticalMovingCircleGenerator.yVelocity = 500
