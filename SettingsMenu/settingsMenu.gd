extends Node


onready var settingsPanel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / settingsPanel
onready var titlePanel = $settingsMenuCanvasLayer / settingsMenuControl / settingsTitle / titlePanel
onready var goBackButton = $settingsMenuCanvasLayer / goBackButton
onready var settingsMainTween = $settingsMainTween
onready var settingsTitle = $settingsMenuCanvasLayer / settingsMenuControl / settingsTitle
onready var actualSettingsControl = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl
onready var titleLabel = $settingsMenuCanvasLayer / settingsMenuControl / settingsTitle / titleLabel
onready var musicButton = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / musicControl / musicButton
onready var musicLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / musicControl / musicLabel
onready var musicButtonLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / musicControl / musicButton / musicButtonLabel
onready var musicButtonTween = $musicButtonTween
onready var showFPSLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / showFPSControl / showFPSLabel
onready var showFPSButtonLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / showFPSControl / showFPSButton / showFPSButtonLabel
onready var showFPSButton = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / showFPSControl / showFPSButton
onready var showFPSButtonTween = $showFPSButtonTween
onready var maxFPSLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / maxFPSControl / maxFPSLabel
onready var maxFPSButtonLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / maxFPSControl / maxFPSButton / maxFPSLabel
onready var maxFPSButtonTween = $maxFPSButtonTween
onready var maxFPSButton = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / maxFPSControl / maxFPSButton
onready var saturationLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / saturationControl / saturationLabel
onready var saturationScroll = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / saturationControl / saturationMargin / saturationScroll
onready var brightnessLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / brightnessControl / brightnessLabel
onready var brightnessScroll = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / brightnessControl / brightnessMargin / brightnessScroll
onready var controlsLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / controlsControl / controlsLabel
onready var controlsButtonLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / controlsControl / controlsButton / controlsButtonLabel
onready var controlsButtonTween = $controlsButtonTween
onready var controlsButton = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / controlsControl / controlsButton
onready var languageLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / languageControl / languageLabel
onready var languageButton = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / languageControl / languageButton
onready var languageButtonLabel = $settingsMenuCanvasLayer / settingsMenuControl / actualSettingsControl / generalMargin / settingsVContainer / languageControl / languageButton / languageButtonLabel
onready var languageButtonTween = $languageButtonTween


onready var animatingMusicButton = false
onready var animatingShowFPSButton = false
onready var animatingMaxFPSButton = false
onready var animatingControlsButton = false
onready var animatingLanguageButton = false



var offTexture = load("res://Resources/Textures/off.png")
var onTexture = load("res://Resources/Textures/on.png")

var buttonAnimTime = 0.3
var totalEnterTime = 1
var slideAnimTime = 0.6

var maxFPS = [0, 20, 30, 60, 120, 144]
var maxFPSIndex

var aviableLocales = ["auto", "es", "en"]
var localeIndex

func setColor():
	settingsPanel.self_modulate = changingColorBackground.oppositeColor
	titlePanel.self_modulate = changingColorBackground.oppositeColor
	goBackButton.self_modulate = changingColorBackground.oppositeColor
	titleLabel.self_modulate = changingColorBackground.color
	musicLabel.self_modulate = changingColorBackground.color
	musicButtonLabel.self_modulate = changingColorBackground.color
	showFPSLabel.self_modulate = changingColorBackground.color
	showFPSButtonLabel.self_modulate = changingColorBackground.color
	maxFPSLabel.self_modulate = changingColorBackground.color
	maxFPSButtonLabel.self_modulate = changingColorBackground.color
	saturationLabel.self_modulate = changingColorBackground.color
	saturationScroll.self_modulate = changingColorBackground.color
	brightnessLabel.self_modulate = changingColorBackground.color
	brightnessScroll.self_modulate = changingColorBackground.color
	controlsLabel.self_modulate = changingColorBackground.color
	controlsButtonLabel.self_modulate = changingColorBackground.color
	languageLabel.self_modulate = changingColorBackground.color
	languageButtonLabel.self_modulate = changingColorBackground.color
	
	
	
	
func _process(delta):
	setColor()
	setText()
	setSaturationFromScroll()
	setBrightnessFromScroll()
	
func setSaturationScrollAtStart():
	
	
	saturationScroll.value = float(userConfig._userConfig["saturation"])
	
	
func setBrightnessScrollAtStart():
	brightnessScroll.value = float(userConfig._userConfig["brightness"])
	
	
func setSaturationFromScroll():
	userConfig._userConfig["saturation"] = saturationScroll.value
	
func setBrightnessFromScroll():
	userConfig._userConfig["brightness"] = brightnessScroll.value
	
	
func setLanguageLabelText():
	var config = userConfig._userConfig["language"]
	if config == "es":
		languageButtonLabel.text = "ESPAÑOL"
	if config == "en":
		languageButtonLabel.text = "ENGLISH"
	if config == "auto":
		languageButtonLabel.text = "AUTO"
func _on_goBackButton_pressed():
	saveLoad.saveUserConfig()
	sceneHandler.goToMainMenu()

func _ready():
	enterMainThings()
	setMusicOnOff()
	setShowFPSOnOff()
	setMaxFPSIndex()
	setLocaleIndex()
	setMaxFPSText()
	setSaturationScrollAtStart()
	setBrightnessScrollAtStart()
	setControlsButtonText()
	setLanguageLabelText()
	
func setLocaleIndex():
	localeIndex = aviableLocales.find(userConfig._userConfig["language"])
	
func setMaxFPSIndex():
	var config = userConfig._userConfig["maxFPS"]
	maxFPSIndex = maxFPS.find(config)
	
	
func setControlsButtonText():
	var config = userConfig._userConfig["gameInputType"]
	if config == "press":
		controlsButtonLabel.text = tr("PRESS")
	if config == "release":
		controlsButtonLabel.text = tr("RELEASE")
	
	
func enterMainThings():
	goBackButton.rect_scale = Vector2(0, 0)
	actualSettingsControl.rect_scale = Vector2(0, 0)
	settingsTitle.rect_scale = Vector2(0, 0)
	actualSettingsControl.rect_pivot_offset = actualSettingsControl.rect_size / 2
	yield (fadeInOutBackground, "animationCompleted")
	settingsMainTween.interpolate_property(actualSettingsControl, "rect_scale", Vector2(0, 1), Vector2(1, 1), (totalEnterTime / 3.0), Tween.TRANS_CIRC, Tween.EASE_OUT)
	settingsMainTween.start()
	yield (settingsMainTween, "tween_completed")
	var desiredYSettingsTitlePos = settingsTitle.rect_position.y
	settingsTitle.rect_position = Vector2(settingsTitle.rect_position.x, desiredYSettingsTitlePos + 165)
	settingsMainTween.interpolate_property(settingsTitle, "rect_position", Vector2(settingsTitle.rect_position.x, desiredYSettingsTitlePos + 165), Vector2(settingsTitle.rect_position.x, desiredYSettingsTitlePos), totalEnterTime / 3.0, Tween.TRANS_CIRC, Tween.EASE_OUT)
	settingsMainTween.start()
	settingsTitle.rect_scale = Vector2(1, 1)
	yield (settingsMainTween, "tween_completed")
	var desiredGoBackButtonPos = goBackButton.rect_position
	goBackButton.rect_position = Vector2(goBackButton.rect_position.x + 200, goBackButton.rect_position.y - 200)
	settingsMainTween.interpolate_property(goBackButton, "rect_position", Vector2(desiredGoBackButtonPos.x + 200, desiredGoBackButtonPos.y - 200), desiredGoBackButtonPos, totalEnterTime / 3.0)
	settingsMainTween.start()
	goBackButton.rect_scale = Vector2(1, 1)
	
	
func setText():
	titleLabel.text = tr("SETTINGS")
	musicLabel.text = tr("MUSIC")
	showFPSLabel.text = tr("SHOW_FPS")
	maxFPSLabel.text = tr("MAX_FPS")
	saturationLabel.text = tr("SATURATION")
	brightnessLabel.text = tr("BRIGHTNESS")
	controlsLabel.text = tr("CONTROLS")
	languageLabel.text = tr("LANGUAGE")
	
	
	
func setMusicOnOff():
	if userConfig._userConfig["music"]:
		musicButtonLabel.text = tr("ON")
	if not userConfig._userConfig["music"]:
		musicButtonLabel.text = tr("OFF")
	

func setShowFPSOnOff():
	if userConfig._userConfig["showFPS"]:
		showFPSButtonLabel.text = tr("ON")
	if not userConfig._userConfig["showFPS"]:
		showFPSButtonLabel.text = tr("OFF")


func setMaxFPSText():
	if maxFPS[maxFPSIndex] != 0:
		maxFPSButtonLabel.text = str(maxFPS[maxFPSIndex])
	if maxFPS[maxFPSIndex] == 0:
		maxFPSButtonLabel.text = "MAX"
		
		
func _on_showFPSButton_pressed():
	if not animatingShowFPSButton:
		animatingShowFPSButton = true
		showFPSButton.rect_pivot_offset = showFPSButton.rect_size / 2
		userConfig._userConfig["showFPS"] = not userConfig._userConfig["showFPS"]
		showFPSButtonTween.interpolate_property(showFPSButton, "rect_scale", showFPSButton.rect_scale, Vector2(0, 0), buttonAnimTime / 2)
		showFPSButtonTween.start()
		yield (showFPSButtonTween, "tween_completed")
		setShowFPSOnOff()
		showFPSButtonTween.interpolate_property(showFPSButton, "rect_scale", showFPSButton.rect_scale, Vector2(1, 1), buttonAnimTime / 2)
		showFPSButtonTween.start()
		yield (showFPSButtonTween, "tween_completed")
		animatingShowFPSButton = false
		
		
	
func _on_musicButton_pressed():
	if not animatingMusicButton:
		animatingMusicButton = true
		musicButton.rect_pivot_offset = musicButton.rect_size / 2
		userConfig._userConfig["music"] = not userConfig._userConfig["music"]
		musicButtonTween.interpolate_property(musicButton, "rect_scale", musicButton.rect_scale, Vector2(0, 0), buttonAnimTime / 2)
		musicButtonTween.start()
		yield (musicButtonTween, "tween_completed")
		setMusicOnOff()
		musicButtonTween.interpolate_property(musicButton, "rect_scale", musicButton.rect_scale, Vector2(1, 1), buttonAnimTime / 2)
		musicButtonTween.start()
		yield (musicButtonTween, "tween_completed")
		animatingMusicButton = false
	


func _on_maxFPSButton_pressed():
	if not animatingMaxFPSButton:
		animatingMaxFPSButton = true
		maxFPSIndex += 1
		if maxFPS.size() - 1 < maxFPSIndex:
			maxFPSIndex = 0
		maxFPSButton.rect_pivot_offset = maxFPSButton.rect_size / 2
		maxFPSButtonTween.interpolate_property(maxFPSButton, "rect_scale", maxFPSButton.rect_scale, Vector2(0, 0), buttonAnimTime / 2)
		maxFPSButtonTween.start()
		yield (maxFPSButtonTween, "tween_completed")
		setMaxFPSText()
		userConfig._userConfig["maxFPS"] = maxFPS[maxFPSIndex]
		maxFPSButtonTween.interpolate_property(maxFPSButton, "rect_scale", maxFPSButton.rect_scale, Vector2(1, 1), buttonAnimTime / 2)
		maxFPSButtonTween.start()
		yield (maxFPSButtonTween, "tween_completed")
		animatingMaxFPSButton = false


func _on_controlsButton_pressed():
	if not animatingControlsButton:
		animatingControlsButton = true
		controlsButton.rect_pivot_offset = controlsButton.rect_size / 2
		if userConfig._userConfig["gameInputType"] == "release":
			userConfig._userConfig["gameInputType"] = "press"
		elif userConfig._userConfig["gameInputType"] == "press":
			userConfig._userConfig["gameInputType"] = "release"
		controlsButtonTween.interpolate_property(controlsButton, "rect_scale", controlsButton.rect_scale, Vector2(0, 0), buttonAnimTime / 2)
		controlsButtonTween.start()
		yield (controlsButtonTween, "tween_completed")
		setControlsButtonText()
		controlsButtonTween.interpolate_property(controlsButton, "rect_scale", controlsButton.rect_scale, Vector2(1, 1), buttonAnimTime / 2)
		controlsButtonTween.start()
		yield (controlsButtonTween, "tween_completed")
		animatingControlsButton = false


func _on_languageButton_pressed():
	if not animatingLanguageButton:
		localeIndex += 1
		if aviableLocales.size() - 1 < localeIndex:
			localeIndex = 0
		animatingLanguageButton = true
		languageButton.rect_pivot_offset = languageButton.rect_size / 2
		languageButtonTween.interpolate_property(languageButton, "rect_scale", languageButton.rect_scale, Vector2(0, 0), buttonAnimTime / 2)
		languageButtonTween.start()
		updateText()
		yield (languageButtonTween, "tween_completed")
		userConfig._userConfig["language"] = aviableLocales[localeIndex]
		setLanguageLabelText()
		languageButtonTween.interpolate_property(languageButton, "rect_scale", languageButton.rect_scale, Vector2(1, 1), buttonAnimTime / 2)
		languageButtonTween.start()
		yield (languageButtonTween, "tween_completed")
		


func updateText():
	settingsMainTween.interpolate_property($settingsMenuCanvasLayer, "offset", Vector2(0, 0), Vector2(1080, 0), slideAnimTime / 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	settingsMainTween.start()
	yield (settingsMainTween, "tween_completed")
	localeSetter.setLanguage()
	setMusicOnOff()
	setShowFPSOnOff()
	setMaxFPSText()
	setControlsButtonText()
	setLanguageLabelText()
	settingsMainTween.interpolate_property($settingsMenuCanvasLayer, "offset", Vector2( - 1080, 0), Vector2(0, 0), slideAnimTime / 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	settingsMainTween.start()
	yield (settingsMainTween, "tween_completed")
	animatingLanguageButton = false
