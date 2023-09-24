extends Node


onready var inGameGUI = $inGameGUICanvasLayer


var player = load("res://Player/playerMain.tscn").instance()

var maxLevelReached = false
var level
var levelTimer
var progress

var levelDuration = {
	"1":50, 
	"2":50, 
	"3":50, 
	"4":50, 
	"5":50, 
	"6":50, 
	"7":50, 
	"8":50, 
	"9":50, 
	"10":100, 
	"11":50, 
	"12":50, 
	"13":50, 
	"14":50, 
	"15":50, 
	"16":50, 
	"17":50, 
	"18":50, 
	"19":50, 
	"20":100, 
	"21":30, 
	"22":35, 
	"23":40, 
	"24":45, 
	"25":50, 
}

var levelReward = {
	"1":10, 
	"2":20, 
	"3":30, 
	"4":40, 
	"5":50, 
	"6":60, 
	"7":70, 
	"8":80, 
	"9":90, 
	"10":100, 
	"11":110, 
	"12":120, 
	"13":130, 
	"14":140, 
	"15":150, 
	"16":160, 
	"17":170, 
	"18":180, 
	"19":190, 
	"20":200, 
	"21":210, 
	"22":220, 
	"23":230, 
	"24":240, 
	"25":250, 
	
}

func init(_level):
	level = _level

func ifLevelIsNull():
	if level == null:
		level = 1

func _ready():
	
	if levelReward.has(str(level)) and levelDuration.has(str(level)):
		ifLevelIsNull()
		setUpPlayer()
		setUpLevel()
		setUpLevelTimer()
	else :
		showMaxLevelReached()
		maxLevelReached = true
	
func setUpPlayer():
	add_child(player)
	player.goToMiddle()
	player.connect("enemyHit", self, "playerEnemyHit")
	
	
func getProgress():
	return progress
func setUpLevel():
	var levelInstance = load("res://ChallengeGame/Levels/level" + str(level) + ".tscn").instance()
	add_child(levelInstance)

		
		
func showMaxLevelReached():
	$maxLevelPopupCanvasLayer.enter()
	

func setProgress():
	var result
	if not maxLevelReached:
		result = ((abs(levelTimer.time_left - levelDuration[str(level)])) / levelDuration[str(level)]) * 100
	else :
		result = 100
	progress = result
	inGameGUI.progress = result
	$inGameGUICanvasLayer / levelProgress / levelLabel.text = str(level)
	
	
func _process(delta):
	setProgress()
	
	
func setUpLevelTimer():
	levelTimer = Timer.new()
	levelTimer.wait_time = levelDuration[str(level)]
	levelTimer.one_shot = true
	levelTimer.connect("timeout", self, "on_levelTimer_timeout")
	add_child(levelTimer)
	levelTimer.start()
	
func on_levelTimer_timeout():
	winGame()
	
func winGame():
	inGameGUI.hasWon = true
	player.win()
	$wonGUICanvasLayer.enter(level, levelReward)
	playerStats._playerStats["diamondNumber"] += levelReward[str(level)]
	playerStats._playerStats["challengeLevel"] += 1
	
	
	
func playerEnemyHit():
	loseGame()
	
func loseGame():
	inGameGUI.hasLost = true
	levelTimer.set_paused(true)
	player.die()
	cameraMain.addShakeTrauma(1)
	$lostGUICanvasLayer.enter(level)
	
