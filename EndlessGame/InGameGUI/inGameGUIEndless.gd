extends CanvasLayer


onready var isPaused = false
onready var canPause = true
onready var hasLost = false

var score
var playerLives
var openPauseMenuDuration = 0.3
var closePauseMenuDuration = 0.3

onready var menuButtonPosition = $inGameGUIMain / menuButtonContainer / menuButton.rect_position
signal mainMenuRequest

func changeColor():
	$inGameGUIMain / GUIBackground.self_modulate = changingColorBackground.oppositeColor
	$inGameGUIMain / scoreInfoVSplit / scoreStringMargin / scoreStringLabel.self_modulate = changingColorBackground.color
	$inGameGUIMain / scoreInfoVSplit / scoreMargin / scoreLabel.self_modulate = changingColorBackground.color
	$inGameGUIMain / pauseButtonContainer / pauseButton.self_modulate = changingColorBackground.color
	$inGameGUIMain / lifeInfoContainer / lifeInfoSplitter / livesIconMargin / livesIcon.self_modulate = changingColorBackground.color
	$inGameGUIMain / lifeInfoContainer / lifeInfoSplitter / livesLabel.self_modulate = changingColorBackground.color
	$inGameGUIMain / menuButtonContainer / menuButton.self_modulate = changingColorBackground.color
	
	
func _ready():
	setUpThings()

	
	
	
func setLivesButtonIconTex():
	$inGameGUIMain / lifeInfoContainer / lifeInfoSplitter / livesIconMargin / livesIcon.texture = skinsInfo.skinsTexture[playerStats._playerStats["selectedSkin"]]
	
	
	
func setUpThings():
	$inGameGUIMain / menuButtonContainer / menuButton.hide()
	$inGameGUIMain / menuButtonContainer / menuButton.rect_pivot_offset = $inGameGUIMain / menuButtonContainer / menuButton.rect_size / 2
	

func _process(delta):
	changeColor()
	updateCanPauseProperties()
	setLivesButtonIconTex()
	setCanPause()
	setText()
func setText():
	if str(score).length() > 7:
		$inGameGUIMain / scoreInfoVSplit / scoreMargin / scoreLabel.get("custom_fonts/font").size = 70
	if str(score).length() > 9:
		$inGameGUIMain / scoreInfoVSplit / scoreMargin / scoreLabel.get("custom_fonts/font").size = 50
		
	$inGameGUIMain / scoreInfoVSplit / scoreStringMargin / scoreStringLabel.text = tr("SCORE") + ":"
	$inGameGUIMain / scoreInfoVSplit / scoreMargin / scoreLabel.text = str(score)
		
	$inGameGUIMain / lifeInfoContainer / lifeInfoSplitter / livesLabel.text = "×" + str(playerLives)
		
func setCanPause():
	if sceneHandler.isChangingScene or hasLost:
		canPause = false
		
	else :
		canPause = true
		
func pauseRequest():
	_on_pauseButton_pressed()


func _on_pauseButton_pressed():
	if canPause:
		get_tree().paused = not get_tree().paused
	if get_tree().paused:
		isPaused = true
	if not get_tree().paused:
		isPaused = false
	if isPaused and canPause:
		openPauseMenu(openPauseMenuDuration)
	if not isPaused and canPause:
		closePauseMenu(closePauseMenuDuration)
	
	
func openPauseMenu(duration):

	changePauseButtonToPaused(duration)
	getInMenuButton(duration)

func changePauseButtonToPaused(duration):
	$inGameGUIMain / pauseButtonContainer / pauseButton.rect_pivot_offset = $inGameGUIMain / pauseButtonContainer / pauseButton.rect_size / 2
	$inGameGUIMain / pauseButtonContainer / pauseButton.show()
	$pauseButtonTween.interpolate_property($inGameGUIMain / pauseButtonContainer / pauseButton, "rect_scale", Vector2(1, 1), Vector2(0, 0), duration / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$pauseButtonTween.start()
	yield ($pauseButtonTween, "tween_completed")
	$inGameGUIMain / pauseButtonContainer / pauseButton.texture_normal = load("res://Resources/Textures/pausePaused.png")
	$pauseButtonTween.interpolate_property($inGameGUIMain / pauseButtonContainer / pauseButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), duration / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$pauseButtonTween.start()

	
	
	
	
func getInMenuButton(duration):
	$inGameGUIMain / menuButtonContainer / menuButton.show()
	popInMenuButton(duration)
	yield ($menuButtonScaleTween, "tween_all_completed")
	slideInMenuButton(duration)
	
func popInMenuButton(duration):
	$menuButtonPositionTween.interpolate_property($inGameGUIMain / menuButtonContainer / menuButton, "rect_position", Vector2(menuButtonPosition.x - 145, menuButtonPosition.y), Vector2(menuButtonPosition.x - 145, menuButtonPosition.y), duration / 5)
	$menuButtonPositionTween.start()
	$menuButtonScaleTween.interpolate_property($inGameGUIMain / menuButtonContainer / menuButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), (duration / 5), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$menuButtonScaleTween.start()
	
func slideInMenuButton(duration):
	
	$menuButtonPositionTween.interpolate_property($inGameGUIMain / menuButtonContainer / menuButton, "rect_position", Vector2(menuButtonPosition.x - 145, menuButtonPosition.y), Vector2(menuButtonPosition.x, menuButtonPosition.y), (duration / 5) * 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$menuButtonPositionTween.start()
	
	
func closePauseMenu(duration):
	getOutMenuButton(duration)
	changePauseButtonToNotPaused(duration)
	
	
func getOutMenuButton(duration):
	slideOutMenuButton(duration)
	yield ($menuButtonPositionTween, "tween_all_completed")
	popOutMenuButton(duration)
	
func popOutMenuButton(duration):
	$menuButtonScaleTween.interpolate_property($inGameGUIMain / menuButtonContainer / menuButton, "rect_scale", Vector2(1, 1), Vector2(0, 0), (duration / 5), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$menuButtonScaleTween.start()
	
func slideOutMenuButton(duration):
	$inGameGUIMain / menuButtonContainer / menuButton.rect_pivot_offset = $inGameGUIMain / menuButtonContainer / menuButton.rect_size / 2
	$menuButtonPositionTween.interpolate_property($inGameGUIMain / menuButtonContainer / menuButton, "rect_position", Vector2(menuButtonPosition.x, menuButtonPosition.y), Vector2(menuButtonPosition.x - 145, menuButtonPosition.y), (duration / 5) * 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$menuButtonPositionTween.start()
	
func changePauseButtonToNotPaused(duration):
	$inGameGUIMain / pauseButtonContainer / pauseButton.rect_pivot_offset = $inGameGUIMain / pauseButtonContainer / pauseButton.rect_size / 2
	$inGameGUIMain / pauseButtonContainer / pauseButton.show()
	$pauseButtonTween.interpolate_property($inGameGUIMain / pauseButtonContainer / pauseButton, "rect_scale", Vector2(1, 1), Vector2(0, 0), duration / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$pauseButtonTween.start()
	yield ($pauseButtonTween, "tween_all_completed")
	$inGameGUIMain / pauseButtonContainer / pauseButton.texture_normal = load("res://Resources/Textures/pauseNotPaused.png")
	$pauseButtonTween.interpolate_property($inGameGUIMain / pauseButtonContainer / pauseButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), duration / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$pauseButtonTween.start()
	
	
func updateCanPauseProperties():
	if canPause:
		$inGameGUIMain / pauseButtonContainer / pauseButton.self_modulate.a = 1
	if not canPause:
		$inGameGUIMain / pauseButtonContainer / pauseButton.self_modulate.a = 0.4


func _on_menuButton_pressed():
	emit_signal("mainMenuRequest")
