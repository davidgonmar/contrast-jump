extends Node


var player = load("res://Player/playerMain.tscn").instance()
onready var verticalMovingCircleGenerator = load("res://Enemies/VerticalMovingCircle/verticalMovingCircleGenerator.tscn").instance()


var scoreTimer
var verticalMovingCircleIsActive
var verticalMovingCircleWaitTime
var verticalMovingCircleNumberOfEnemies
var verticalMovingCircleNumberOfLayers
var verticalMovingCircleYVelocity


var diamondMultiplier
var scoreMultiplier
var bestScoreAtStart
onready var stage = 0
var playerLives
var score
var previousStage

signal stageChanged()

func _ready():
	hideLostGUI()
	connectSignals()
	setUpVariables()
	setUpCircleGenerator()
	setUpPlayer()
	setUpScoreTimer()
	setStage()

	
func hideLostGUI():
	$lostGUICanvasLayer._hide()
	
func showLostGUI():
	$lostGUICanvasLayer._show()
	
	
func getInLostGUI(score, bestScoreAtStart):
	$lostGUICanvasLayer.getIn(score, bestScoreAtStart)

func connectSignals():
	$inGameGUICanvasLayer.connect("mainMenuRequest", self, "mainMenuRequestDuringGame")
	$lostGUICanvasLayer.connect("goToMenu", self, "mainMenuRequestAfterLost")
	$lostGUICanvasLayer.connect("tryAgain", self, "tryAgainAfterLost")
	

func _process(delta):
	setDiff()
	syncDiff()
	setStage()
	checkForStageChange()
	GUIPassValue()

func scoreInRange(minValue, maxValue):
	if score >= minValue and score <= maxValue:
		return true
	else :
		return false
		
		
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		$inGameGUICanvasLayer.pauseRequest()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$inGameGUICanvasLayer.pauseRequest()
		
func setStage():
	if scoreInRange(1, 15):
		stage = 1
	if scoreInRange(16, 40):
		stage = 2
	if scoreInRange(41, 75):
		stage = 3
	if scoreInRange(75, 150):
		stage = 4
	if scoreInRange(151, 225):
		stage = 5
	if scoreInRange(226, 325):
		stage = 6
	if scoreInRange(325, 450):
		stage = 7
	if scoreInRange(451, 600):
		stage = 8
	if scoreInRange(601, 750):
		stage = 9
	if scoreInRange(751, 1000):
		stage = 10
		
func checkForStageChange():
	if stage != previousStage:
		stageChanged()
		previousStage = stage

func stageChanged():
		$stageLabelCanvasLayer.enter(stage)
	
	
	
func setUpVariables():
	var selectedSkin = playerStats._playerStats["selectedSkin"]
	previousStage = 0
	scoreMultiplier = skinsInfo.skinsStats[selectedSkin]["multiplier"]
	score = 0
	playerLives = skinsInfo.skinsStats[selectedSkin]["lives"]
	bestScoreAtStart = playerStats._playerStats["bestScore"]
	if playerStats._playerStats["hasDoubleDiamonds"]:
		diamondMultiplier = 2
	if not playerStats._playerStats["hasDoubleDiamonds"]:
		diamondMultiplier = 1
		
		
func setUpCircleGenerator():
	add_child(verticalMovingCircleGenerator)

func setUpPlayer():
	add_child(player)
	player.goToMiddle()
	player.connect("enemyHit", self, "playerEnemyHit")


	
func setDiff():
	match stage:
		1:changeDiff(true, 3, 2, 4, 200)
		2:changeDiff(true, 2.75, 3, 6, 225)
		3:changeDiff(true, 2.5, 3, 6, 250)
		4:changeDiff(true, 2.25, 3, 6, 275)
		5:changeDiff(true, 2, 3, 6, 300)
		6:changeDiff(true, 1.75, 3, 6, 325)
		7:changeDiff(true, 1.5, 3, 6, 350)
		8:changeDiff(true, 1.35, 3, 6, 375)
		9:changeDiff(true, 1.25, 3, 6, 400)
		10:changeDiff(true, 1.15, 3, 6, 425)
		_:changeDiff(false, 0, 0, 0, 0)
	
func changeDiff(_verticalMovingCircleIsActive, _verticalMovingCircleWaitTime, _verticalMovingCircleNumberOfEnemies, _verticalMovingCircleNumberOfLayers, _verticalMovingCircleYVelocity):
	verticalMovingCircleIsActive = _verticalMovingCircleIsActive
	verticalMovingCircleWaitTime = _verticalMovingCircleWaitTime
	verticalMovingCircleNumberOfEnemies = _verticalMovingCircleNumberOfEnemies
	verticalMovingCircleNumberOfLayers = _verticalMovingCircleNumberOfLayers
	verticalMovingCircleYVelocity = _verticalMovingCircleYVelocity
	
func syncDiff():
	verticalMovingCircleGenerator.isActive = verticalMovingCircleIsActive
	verticalMovingCircleGenerator.waitTime = verticalMovingCircleWaitTime
	verticalMovingCircleGenerator.numberOfEnemies = verticalMovingCircleNumberOfEnemies
	verticalMovingCircleGenerator.numberOfLayers = verticalMovingCircleNumberOfLayers
	verticalMovingCircleGenerator.yVelocity = verticalMovingCircleYVelocity
	
	
func playerEnemyHit():
	playerLives -= 1
	if playerLives >= 1:
		player.startRecuperation()
		cameraMain.addShakeTrauma(0.6)
	if playerLives < 1:
		playerLives = 0
		gameOver()

	
func addScore(x):
	score += x * scoreMultiplier
	playerStats._playerStats["diamondNumber"] += x * diamondMultiplier * scoreMultiplier
	
	
func setUpScoreTimer():
	scoreTimer = Timer.new()
	scoreTimer.one_shot = false
	scoreTimer.autostart = false
	scoreTimer.wait_time = 1.0
	scoreTimer.connect("timeout", self, "on_scoreTimer_timeout")
	add_child(scoreTimer)
	scoreTimer.start()
	
	
func on_scoreTimer_timeout():
	addScore(1)
	
	scoreTimer.start()
	

func gameOver():
	scoreTimer.stop()
	player.die()
	shakeScreen()
	updatePlayerVariables()
	$inGameGUICanvasLayer.hasLost = true
	getInLostGUI(score, bestScoreAtStart)
	saveLoad.savePlayerStats()
	
	
func updatePlayerVariables():
	if score > bestScoreAtStart:
		playerStats._playerStats["bestScore"] = score
	if stage > playerStats._playerStats["bestStage"]:
		playerStats._playerStats["bestStage"] = stage
		
func shakeScreen():
	cameraMain.addShakeTrauma(1)
	
func setCanPause(_bool:bool):
	$inGameGUICanvasLayer.canPause = false
	
func GUIPassValue():
	$inGameGUICanvasLayer.score = score
	$inGameGUICanvasLayer.playerLives = playerLives

func mainMenuRequestDuringGame():
	sceneHandler.goToMainMenu()


func mainMenuRequestAfterLost():
	sceneHandler.goToMainMenu()
	
func tryAgainAfterLost():
	sceneHandler.newEndlessGame()
			
