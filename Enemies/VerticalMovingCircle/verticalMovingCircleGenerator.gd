extends Node

onready var _screenSize = screenSize._screenSize
onready var enemyScene = load("res://Enemies/VerticalMovingCircle/circleMain.tscn")
onready var distanceBetweenEnemiesRatio = 0.95
var margin
var generatorTimer
var isActive
var waitTime
var numberOfEnemies
var numberOfLayers
var yVelocity


func setUpTimer():
	generatorTimer = Timer.new()
	generatorTimer.autostart = false
	generatorTimer.connect("timeout", self, "_on_generatortimer_timeout")
	add_child(generatorTimer)
	generatorTimer.start()


func setDefaults():
	isActive = true
	waitTime = 1
	numberOfEnemies = 100
	numberOfLayers = 100
	yVelocity = 100
	
func _ready():
	setUpTimer()
	setDefaults()
	
func _on_generatortimer_timeout():
	newRound()
		
func regulateActivity():
	if isActive:
		generatorTimer.set_paused(false)
	if not isActive:
		generatorTimer.set_paused(true)
		
func newRound():
	var positions = getRandomXPos(numberOfLayers, numberOfEnemies, _screenSize)
	generate(positions, yVelocity)
	

func _process(delta):
	syncTimerWaitTime()
	regulateActivity()
	
func syncTimerWaitTime():
	generatorTimer.wait_time = waitTime
	
func getRandomXPos(numberOfLayers, numberOfEnemies, _screenSize):
	var result = []
	randomize()
	var posIndex = []
	for i in range(0, numberOfEnemies):
		posIndex.append(null)
		result.append(null)
		var generatedNumber
		var isRepeated
		var arraySize = posIndex.size()
		while isRepeated or isRepeated == null:
			isRepeated = false
			generatedNumber = randi() % numberOfLayers
			for j in range(0, arraySize):
				if generatedNumber == posIndex[j]:
					isRepeated = true
				
				
		posIndex[i] = generatedNumber
		calcMargin(_screenSize.x, numberOfLayers)
		if numberOfLayers == 1:
			result[i] = _screenSize.x / 2
		else :
			result[i] = (posIndex[i] * ((_screenSize.x - 2 * margin) / (numberOfLayers - 1))) + margin
		
		
		
	return result
		
func calcMargin(_screenSizeX, numberOfLayers):
	margin = (_screenSizeX / numberOfLayers) / 2
	
	
func generate(positions:Array, velocity):
	var posSize = positions.size()
	for i in range(0, posSize):
		var enemy = enemyScene.instance()
		add_child(enemy)
		enemy.position = Vector2(positions[i], - 500)
		enemy.yVelocity = yVelocity
		setCircleScale(enemy)

func setCircleScale(enemy):
	var currentSize = enemy.size
	var desiredSize = (_screenSize.x / numberOfLayers) * distanceBetweenEnemiesRatio
	var scaleMult = desiredSize / currentSize
	enemy.scale *= scaleMult
	
	
