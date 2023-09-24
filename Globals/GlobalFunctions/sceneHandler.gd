extends Node

var endlessGameScene = load("res://EndlessGame/gameMain.tscn")
var mainMenuScene = load("res://MainMenu/mainMenu.tscn")
var storeScene = load("res://Store/storeMain.tscn")
var challengeGameScene = load("res://ChallengeGame/challengeGameMain.tscn")
var settingsMenuScene = load("res://SettingsMenu/settingsMenu.tscn")


onready var isChangingScene = false



	
	
func newEndlessGame():
	if not isChangingScene:
		isChangingScene = true
		fadeInOutBackground.initiateMode("inOut")
		yield (fadeInOutBackground, "halfAnimationCompleted")
		removeAllChildren()
		saveLoad.savePlayerStats()
		var endlessGameInstance = endlessGameScene.instance()
		add_child(endlessGameInstance)
		setNotPaused()
		yield (fadeInOutBackground, "animationCompleted")
		isChangingScene = false

	
func removeAllChildren():
	for i in get_child_count():
		get_child(i).queue_free()
		remove_child(get_child(i))
		
		
		
func goToMainMenu():
	if not isChangingScene:
		isChangingScene = true
		fadeInOutBackground.initiateMode("inOut")
		yield (fadeInOutBackground, "halfAnimationCompleted")
		removeAllChildren()
		saveLoad.savePlayerStats()
		add_child(mainMenuScene.instance())
		setNotPaused()
		yield (fadeInOutBackground, "animationCompleted")
		isChangingScene = false
	
	
func goToStore():
	if not isChangingScene:
		isChangingScene = true
		fadeInOutBackground.initiateMode("inOut")
		yield (fadeInOutBackground, "halfAnimationCompleted")
		removeAllChildren()
		saveLoad.savePlayerStats()
		var storeInstance = storeScene.instance()
		add_child(storeInstance)
		setNotPaused()
		yield (fadeInOutBackground, "animationCompleted")
		isChangingScene = false
	
	
	
func newChallengeGame(level):
	if not isChangingScene:
		isChangingScene = true
		fadeInOutBackground.initiateMode("inOut")
		yield (fadeInOutBackground, "halfAnimationCompleted")
		removeAllChildren()
		saveLoad.savePlayerStats()
		var challengeGameInstance = challengeGameScene.instance()
		challengeGameInstance.init(level)
		add_child(challengeGameInstance)
		setNotPaused()
		yield (fadeInOutBackground, "animationCompleted")
		isChangingScene = false
	
	
func goToSettings():
	if not isChangingScene:
		isChangingScene = true
		fadeInOutBackground.initiateMode("inOut")
		yield (fadeInOutBackground, "halfAnimationCompleted")
		removeAllChildren()
		saveLoad.savePlayerStats()
		var settingsMenuInstance = settingsMenuScene.instance()
		add_child(settingsMenuInstance)
		setNotPaused()
		yield (fadeInOutBackground, "animationCompleted")
		isChangingScene = false
		
		
func setNotPaused():
	get_tree().paused = false

