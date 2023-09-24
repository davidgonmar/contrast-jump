extends Node



var sceneDuration = 2.25
var fadeInDarverokLabelDur = 0.75
var fadeInDarverokLabelDelay = 0.5
onready var darverokLabelAlpha = 0

onready var errorLoadingMenu = $errorLoadingMenu
func _ready():
	errorLoadingMenu.rect_scale = Vector2(0, 0)
	waitAndGoToMainMenuAndPlayMusic()
	initiateDarverokLabel()
	
func initiateDarverokLabel():
	yield (get_tree().create_timer(fadeInDarverokLabelDelay), "timeout")
	$darverokLabelTween.interpolate_method(self, "setDarverokLabelAlpha", 0, 1, fadeInDarverokLabelDur)
	$darverokLabelTween.start()
	
	
func _process(delta):
	setColor()
	
func waitAndGoToMainMenuAndPlayMusic():
	saveLoad.loadPlayerStats()
	saveLoad.loadUserConfig()
	localeSetter.setLanguage()
	yield (get_tree().create_timer(sceneDuration), "timeout")
	if saveLoad.isError:
		popupErrorMenu()
	elif saveLoad.isLoaded:
		
		audioHandler.playMusic()
		sceneHandler.goToMainMenu()
		yield (fadeInOutBackground, "halfAnimationCompleted")
		self.queue_free()
		
	
func setDarverokLabelAlpha(value):
	darverokLabelAlpha = value


func setColor():
	$darverokLabel.self_modulate = changingColorBackground.oppositeColor
	$darverokLabel.self_modulate.a = darverokLabelAlpha
	$errorLoadingMenu / errorPanel.self_modulate = changingColorBackground.oppositeColor
	$errorLoadingMenu / textMargin / errorLabel.self_modulate = changingColorBackground.color
	$errorLoadingMenu / buttonContainer / xButton.add_color_override("font_color", changingColorBackground.oppositeColor)
	$errorLoadingMenu / buttonContainer / xButton.add_color_override("font_color_disabled", changingColorBackground.oppositeColor)
	$errorLoadingMenu / buttonContainer / xButton.add_color_override("font_color_hover", changingColorBackground.oppositeColor)
	$errorLoadingMenu / buttonContainer / xButton.add_color_override("font_color_pressed", changingColorBackground.oppositeColor)
	$errorLoadingMenu / buttonContainer / xButton.get("custom_styles/normal").bg_color = changingColorBackground.color
func popupErrorMenu():
	errorLoadingMenu.rect_pivot_offset = errorLoadingMenu.rect_size / 2
	$errorLoadingMenu / textMargin / errorLabel.text = tr("LOADING_ERROR")
	$errorMenuTween.interpolate_property(errorLoadingMenu, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.5)
	$errorMenuTween.start()


func _on_xButton_pressed():
	get_tree().quit()
