extends Node




var verticalMovingCircleGenerator = load("res://Enemies/VerticalMovingCircle/verticalMovingCircleGenerator.tscn").instance()
func _ready():
	setUpVMCircleGenerator()
	
	

func setUpVMCircleGenerator():
	add_child(verticalMovingCircleGenerator)
	verticalMovingCircleGenerator.isActive = true
	verticalMovingCircleGenerator.waitTime = 2.65
	verticalMovingCircleGenerator.numberOfEnemies = 2
	verticalMovingCircleGenerator.numberOfLayers = 4
	verticalMovingCircleGenerator.yVelocity = 340
