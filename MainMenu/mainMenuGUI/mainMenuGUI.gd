extends CanvasLayer

onready var playButton = $shopPlaySettingsGUIMain / hContainer / playButtonContainer / playButton
onready var titleLabel = $titleLabelContainer / titleLabelMargin / titleLabel
onready var titleLabelTween = $titleLabelTween
onready var playButtonTween = $playButtonTween
onready var bestScoreLabel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / bestScoreMargin / bestScoreLabel
onready var bestStageLabel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / bestStageMargin / bestStageLabel
onready var bestScoreAndStageAndLevelTween = $bestScoreAndStageAndLevelTween
onready var bestScoreAndStageAndLevelContainer = $bestScoreAndStageAndLevelContainer
onready var bestScorePanel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / bestScoreMargin / bestScorePanel
onready var bestStagePanel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / bestStageMargin / bestStagePanel
onready var challengeLevelPanel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / challengeLevelMargin / challengeLevelPanel
onready var challengeLevelLabel = $bestScoreAndStageAndLevelContainer / bestScoreAndStageAndLevelSplitter / challengeLevelMargin / challengeLebelLabel
onready var storeButton = $shopPlaySettingsGUIMain / hContainer / storeButtonContainer / storeButton
onready var storeButtonTween = $storeButtonTween
onready var playMenuContainer = $playMenuContainer
onready var playMenuTween = $playMenuTween
onready var playMenuPanel = $playMenuContainer / playMenuPanel
onready var endlessButton = $playMenuContainer / playMenuVSplitter / endlessButtonMargin / endlessButton
onready var challengeButton = $playMenuContainer / playMenuVSplitter / challengeButtonMargin / challengeButton
onready var settingsButton = $shopPlaySettingsGUIMain / hContainer / settingsButtonContainer / settingsButton
onready var settingsButtonTween = $settingsButtonTween

onready var animatePlayButton = true
onready var animateTitleLabel = true
onready var animateBestScoreAndStageLabel = true
onready var animateStoreButton = true
onready var animateSettingsButton = true


onready var gameMenuIsOpen = false
onready var animatingGameMenu = false


var statsWidgetOpeningTime = 0.7
var titleLabelOpeningTime = 0.7
var bestScoreAndStageAndLevelOpeningTime = 0.7
var playButtonOpeningTime = 0.7
var storeButtonOpeningTime = 0.7
var playMenuOpeningTime = 0.25
var playMenuClosingTime = 0.25
var settingsButtonOpeningTime = 0.7



func _on_playButton_pressed():
	openGameSelectionMenu()
	
	
func setPlayMenuText():
	endlessButton.text = tr("ENDLESS")
	challengeButton.text = tr("CHALLENGE")
	
func openGameSelectionMenu():
	if not gameMenuIsOpen and not animatingGameMenu:
		animatingGameMenu = true
		playMenuContainer.rect_pivot_offset = playMenuContainer.rect_size / 2
		playMenuTween.interpolate_property(playMenuContainer, "rect_scale", Vector2(0, 0), Vector2(1, 1), playMenuOpeningTime)
		playMenuTween.start()
		yield (playMenuTween, "tween_completed")
		gameMenuIsOpen = true
		animatingGameMenu = false
	
func closeGameSelectionMenu():
	if gameMenuIsOpen and not animatingGameMenu:
		animatingGameMenu = true
		playMenuContainer.rect_pivot_offset = playMenuContainer.rect_size / 2
		playMenuTween.interpolate_property(playMenuContainer, "rect_scale", Vector2(1, 1), Vector2(0, 0), playMenuClosingTime)
		playMenuTween.start()
		yield (playMenuTween, "tween_completed")
		gameMenuIsOpen = false
		animatingGameMenu = false
	
func detectClickOutsideGameMenu():
	var rect = Rect2(playMenuContainer.rect_position, playMenuContainer.rect_size)
	if Input.is_action_pressed("Click"):
		if gameMenuIsOpen:
			if not rect.has_point(playMenuContainer.get_global_mouse_position()):
				closeGameSelectionMenu()
			
func animatePlayButton():
	playButton.rect_pivot_offset = playButton.rect_size / 2
	playButtonTween.interpolate_property(playButton, "rect_scale", Vector2(0, 0), Vector2(0, 0), 0)
	playButtonTween.start()
	yield (fadeInOutBackground, "animationCompleted")
	playButtonTween.interpolate_property(playButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), playButtonOpeningTime)
	playButtonTween.start()
	yield (playButtonTween, "tween_completed")
	
	while animatePlayButton:
		playButtonTween.interpolate_property(playButton, "rect_scale", Vector2(1, 1), Vector2(1.1, 1.1), 0.45)
		playButtonTween.start()
		yield (playButtonTween, "tween_completed")
		playButtonTween.interpolate_property(playButton, "rect_scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.45)
		playButtonTween.start()
		yield (playButtonTween, "tween_completed")
		
	
func setColor():
	playButton.self_modulate = changingColorBackground.oppositeColor
	titleLabel.self_modulate = changingColorBackground.oppositeColor
	bestScoreLabel.self_modulate = changingColorBackground.color
	bestStageLabel.self_modulate = changingColorBackground.color
	bestStagePanel.self_modulate = changingColorBackground.oppositeColor
	bestScorePanel.self_modulate = changingColorBackground.oppositeColor
	challengeLevelLabel.self_modulate = changingColorBackground.color
	challengeLevelPanel.self_modulate = changingColorBackground.oppositeColor
	storeButton.self_modulate = changingColorBackground.oppositeColor
	playMenuPanel.self_modulate = changingColorBackground.oppositeColor
	endlessButton.get("custom_styles/normal").bg_color = changingColorBackground.color
	endlessButton.add_color_override("font_color", changingColorBackground.oppositeColor)
	endlessButton.add_color_override("font_color_disabled", changingColorBackground.oppositeColor)
	endlessButton.add_color_override("font_color_hover", changingColorBackground.oppositeColor)
	endlessButton.add_color_override("font_color_pressed", changingColorBackground.oppositeColor)
	challengeButton.add_color_override("font_color", changingColorBackground.oppositeColor)
	challengeButton.add_color_override("font_color_disabled", changingColorBackground.oppositeColor)
	challengeButton.add_color_override("font_color_hover", changingColorBackground.oppositeColor)
	challengeButton.add_color_override("font_color_pressed", changingColorBackground.oppositeColor)
	settingsButton.self_modulate = changingColorBackground.oppositeColor
	
func setBestScoreAndStageAndLevelText():
	bestScoreLabel.text = tr("BEST_SCORE") + ": " + str(playerStats._playerStats["bestScore"])
	if str(playerStats._playerStats["bestScore"]).length() > 6:
		bestScoreLabel.get("custom_fonts/font").size = 50
	if str(playerStats._playerStats["bestScore"]).length() > 10:
		bestScoreLabel.get("custom_fonts/font").size = 40
	bestStageLabel.text = tr("BEST_STAGE") + ": " + str(playerStats._playerStats["bestStage"])
	challengeLevelLabel.text = tr("CHALLENGE_LEVEL") + ": " + str(playerStats._playerStats["challengeLevel"])
	
func animateBestScoreAndStageAndLevelLabel():
	bestScoreAndStageAndLevelContainer.rect_pivot_offset = bestScoreAndStageAndLevelContainer.rect_size / 2
	bestScoreAndStageAndLevelContainer.rect_position = Vector2( - 1000, 580)
	yield (fadeInOutBackground, "animationCompleted")
	bestScoreAndStageAndLevelTween.interpolate_property(bestScoreAndStageAndLevelContainer, "rect_position", Vector2( - 1000, 800), Vector2(0, 800), bestScoreAndStageAndLevelOpeningTime, Tween.TRANS_QUAD, Tween.EASE_OUT)
	bestScoreAndStageAndLevelTween.start()
	yield (bestScoreAndStageAndLevelTween, "tween_completed")
	while animateBestScoreAndStageLabel:
		bestScoreAndStageAndLevelTween.interpolate_property(bestScoreAndStageAndLevelContainer, "rect_rotation", 0, 2, 0.4)
		bestScoreAndStageAndLevelTween.start()
		yield (bestScoreAndStageAndLevelTween, "tween_completed")
		bestScoreAndStageAndLevelTween.interpolate_property(bestScoreAndStageAndLevelContainer, "rect_rotation", 2, 0, 0.4)
		bestScoreAndStageAndLevelTween.start()
		yield (bestScoreAndStageAndLevelTween, "tween_completed")
		bestScoreAndStageAndLevelTween.interpolate_property(bestScoreAndStageAndLevelContainer, "rect_rotation", 0, - 2, 0.4)
		bestScoreAndStageAndLevelTween.start()
		yield (bestScoreAndStageAndLevelTween, "tween_completed")
		bestScoreAndStageAndLevelTween.interpolate_property(bestScoreAndStageAndLevelContainer, "rect_rotation", - 2, 0, 0.4)
		bestScoreAndStageAndLevelTween.start()
		yield (bestScoreAndStageAndLevelTween, "tween_completed")
	
	
func _process(delta):
	setColor()
	setBestScoreAndStageAndLevelText()
	setStoreButtonTexture()
	setPlayMenuText()
	detectClickOutsideGameMenu()
func setStoreButtonTexture():
	storeButton.texture_normal = skinsInfo.skinsTexture[playerStats._playerStats["selectedSkin"]]
	
	
	
func animateTitleLabel():
	titleLabel.rect_pivot_offset = titleLabel.rect_size / 2
	titleLabel.percent_visible = 0
	yield (fadeInOutBackground, "animationCompleted")
	titleLabelTween.interpolate_property(titleLabel, "percent_visible", 0, 1, titleLabelOpeningTime)
	titleLabelTween.start()
	yield (titleLabelTween, "tween_completed")
	
	while animateTitleLabel:
		titleLabelTween.interpolate_property(titleLabel, "rect_position", titleLabel.rect_position, Vector2(titleLabel.rect_position.x, titleLabel.rect_position.y + 50), 0.5, Tween.TRANS_QUART, Tween.EASE_IN)
		titleLabelTween.start()
		yield (titleLabelTween, "tween_completed")
		titleLabelTween.interpolate_property(titleLabel, "rect_position", titleLabel.rect_position, Vector2(titleLabel.rect_position.x, titleLabel.rect_position.y - 50), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		titleLabelTween.start()
		yield (titleLabelTween, "tween_completed")


	
	
func _ready():
	animateTitleLabel()
	animatePlayButton()
	animateBestScoreAndStageAndLevelLabel()
	animateStoreButton()
	hidePlayMenu()
	animateSettingsButton()
func hidePlayMenu():
	playMenuContainer.rect_scale = Vector2(0, 0)
	
func animateStoreButton():
	storeButton.rect_pivot_offset = storeButton.rect_size / 2
	storeButtonTween.interpolate_property(storeButton, "rect_scale", Vector2(0, 0), Vector2(0, 0), 0)
	storeButtonTween.start()
	yield (fadeInOutBackground, "animationCompleted")
	storeButtonTween.interpolate_property(storeButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), storeButtonOpeningTime)
	storeButtonTween.start()
	yield (storeButtonTween, "tween_completed")
	while animateStoreButton:
		storeButtonTween.interpolate_property(storeButton, "rect_rotation", 0, 360, 12)
		storeButtonTween.start()
		yield (storeButtonTween, "tween_completed")
		
		
		
func animateSettingsButton():
	settingsButton.rect_pivot_offset = settingsButton.rect_size / 2
	settingsButtonTween.interpolate_property(settingsButton, "rect_scale", Vector2(0, 0), Vector2(0, 0), 0)
	settingsButtonTween.start()
	yield (fadeInOutBackground, "animationCompleted")
	settingsButtonTween.interpolate_property(settingsButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), settingsButtonOpeningTime)
	settingsButtonTween.start()
	yield (settingsButtonTween, "tween_completed")
	while animateSettingsButton:
		settingsButtonTween.interpolate_property(settingsButton, "rect_rotation", 0, 360, 12)
		settingsButtonTween.start()
		yield (settingsButtonTween, "tween_completed")
		
	
func roundNumber(number, digits):
	return round(number * pow(10.0, digits)) / pow(10.0, digits)


func _on_storeButton_pressed():
	sceneHandler.goToStore()


func _on_endlessButton_pressed():
	sceneHandler.newEndlessGame()
	

func _on_challengeButton_pressed():
	sceneHandler.newChallengeGame(playerStats._playerStats["challengeLevel"])


func _on_settingsButton_pressed():
	sceneHandler.goToSettings()
