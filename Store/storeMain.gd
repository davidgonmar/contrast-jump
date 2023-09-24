extends Node



onready var skinTextureRect = $storeCanvasLayer / storeControl / skinSelector / skinTextureRectClipper / skinTextureRect
onready var skinTextureScrollTween = $skinTextureScrollTween
onready var rightButton = $storeCanvasLayer / storeControl / skinSelector / rightButton
onready var leftButton = $storeCanvasLayer / storeControl / skinSelector / leftButton
onready var rightButtonTween = $rightButtonTween
onready var leftButtonTween = $leftButtonTween
onready var skinTextureRectClipper = $storeCanvasLayer / storeControl / skinSelector / skinTextureRectClipper
onready var skinTextureScaleTween = $skinTextureScaleTween
onready var buySkinButton = $storeCanvasLayer / storeControl / skinSelector / buySkinButton
onready var buySkinButtonTween = $buySkinButtonTween
onready var skinPriceLabel = $storeCanvasLayer / storeControl / skinSelector / buySkinButton / priceLabel
onready var diamondSkinIconTexture = $storeCanvasLayer / storeControl / skinSelector / buySkinButton / iconTexture
onready var diamondsInfoIcon = $storeCanvasLayer / storeControl / diamondsInfo / diamondsInfoContainer / diamondsInfoIcon
onready var diamondsInfoBackground = $storeCanvasLayer / storeControl / diamondsInfo / diamondsInfoContainer / diamondsInfoBackground
onready var diamondsInfoLabel = $storeCanvasLayer / storeControl / diamondsInfo / diamondsInfoContainer / diamondsInfoBackground / diamondsInfoLabel
onready var skinUnlockAlphaTween = $skinUnlockAlphaTween
onready var skinUnlockRotationTween = $skinUnlockRotationTween
onready var xButton = $storeCanvasLayer / xButtonMargin / xButton
onready var diamondLabelText = $diamondNumberTween
onready var diamondNumberTween = $diamondNumberTween
onready var statsWidgetPanel = $storeCanvasLayer / skinStatsWidget / skinStatsPanel
onready var multiplierLabel = $storeCanvasLayer / skinStatsWidget / skinStatsMargin / skinStatsVSplitter / multiplierLabel
onready var livesLabel = $storeCanvasLayer / skinStatsWidget / skinStatsMargin / skinStatsVSplitter / livesLabel
onready var recuperationLabel = $storeCanvasLayer / skinStatsWidget / skinStatsMargin / skinStatsVSplitter / recuperationLabel
onready var skinStatsTitle = $storeCanvasLayer / skinStatsWidget / skinStatsTitleContainer / skinStatsTitle





onready var diamondsInfoLabelText = str(playerStats._playerStats["diamondNumber"]) setget setDiamondsLabelText
onready var skinIndex = skinsInfo.skinsIndex.find(playerStats._playerStats["selectedSkin"])

var scrollAnimDuration = 0.35
var makeButtonBiggerAndSmallerDur = 0.35
var skinTexturRectAnimDur = 0.75
var buyButtonAnimDur = 0.175
var skinUnlockAnimDur = 2.5
var diamondNumberAnimDur = 2.5

var buySkinButtonIsOn
var skinAlpha

var skinIsTransitioning = false
var animateSkin = true

func setColor():
	skinTextureRect.self_modulate = changingColorBackground.oppositeColor
	skinTextureRect.self_modulate.a = skinAlpha
	rightButton.self_modulate = changingColorBackground.oppositeColor
	leftButton.self_modulate = changingColorBackground.oppositeColor
	buySkinButton.get("custom_styles/normal").bg_color = changingColorBackground.oppositeColor
	skinPriceLabel.self_modulate = changingColorBackground.color
	diamondSkinIconTexture.self_modulate = changingColorBackground.color
	diamondsInfoBackground.self_modulate = changingColorBackground.oppositeColor
	diamondsInfoIcon.self_modulate = changingColorBackground.color
	diamondsInfoLabel.self_modulate = changingColorBackground.color
	xButton.self_modulate = changingColorBackground.oppositeColor
	statsWidgetPanel.self_modulate = changingColorBackground.oppositeColor
	multiplierLabel.self_modulate = changingColorBackground.color
	livesLabel.self_modulate = changingColorBackground.color
	recuperationLabel.self_modulate = changingColorBackground.color
	skinStatsTitle.self_modulate = changingColorBackground.color
	
	
	
func updateSkinsStats():
	skinStatsTitle.text = tr("ENDLESS_STATS")
	multiplierLabel.text = tr("MULTIPLIER") + ": ×" + str(skinsInfo.skinsStats[skinsInfo.skinsIndex[skinIndex]]["multiplier"])
	livesLabel.text = tr("LIVES") + ": " + str(skinsInfo.skinsStats[skinsInfo.skinsIndex[skinIndex]]["lives"])
	recuperationLabel.text = tr("RECUPERATION") + ": " + str(skinsInfo.skinsStats[skinsInfo.skinsIndex[skinIndex]]["recuperation"]) + "s"
	
func updateDiamondsLabelText():
	diamondsInfoLabel.text = diamondsInfoLabelText
	
	
	
func updateSkinTexture(mode):
	if mode == "right":
		skinIsTransitioning = true
		skinTextureScrollTween.interpolate_property(skinTextureRect, "rect_position", Vector2(0, 0), Vector2(310, 0), scrollAnimDuration / 2)
		skinTextureScrollTween.start()
		yield (skinTextureScrollTween, "tween_completed")
		skinTextureRect.texture = skinsInfo.skinsTexture[skinsInfo.skinsIndex[skinIndex]]
		if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]]:
			skinAlpha = 1
		else :
			skinAlpha = 0.4
		updateBuySkinButton()
		updateSkinsStats()
		skinTextureScrollTween.interpolate_property(skinTextureRect, "rect_position", Vector2( - 310, 0), Vector2(0, 0), scrollAnimDuration / 2)
		skinTextureScrollTween.start()
		yield (skinTextureScrollTween, "tween_completed")
		skinIsTransitioning = false
	
	if mode == "left":
		skinIsTransitioning = true
		skinTextureScrollTween.interpolate_property(skinTextureRect, "rect_position", Vector2(0, 0), Vector2( - 310, 0), scrollAnimDuration / 2)
		skinTextureScrollTween.start()
		yield (skinTextureScrollTween, "tween_completed")
		skinTextureRect.texture = skinsInfo.skinsTexture[skinsInfo.skinsIndex[skinIndex]]
		if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]]:
			skinAlpha = 1
		else :
			skinAlpha = 0.4
		updateBuySkinButton()
		updateSkinsStats()
		skinTextureScrollTween.interpolate_property(skinTextureRect, "rect_position", Vector2(310, 0), Vector2(0, 0), scrollAnimDuration / 2)
		skinTextureScrollTween.start()
		yield (skinTextureScrollTween, "tween_completed")
		skinIsTransitioning = false
		
		
	if mode == "unlock":
		skinIsTransitioning = true
		skinUnlockAlphaTween.interpolate_method(self, "setSkinAlpha", skinAlpha, 1, skinUnlockAnimDur)
		skinUnlockRotationTween.interpolate_property(skinTextureRect, "rect_rotation", 0, 2880, skinUnlockAnimDur, Tween.TRANS_QUAD, Tween.EASE_OUT)
		skinTextureRectClipper.rect_clip_content = false
		skinUnlockRotationTween.start()
		skinUnlockAlphaTween.start()
		updateBuySkinButton()
		updateSkinsStats()
		yield (skinUnlockAlphaTween, "tween_completed")
		skinTextureRectClipper.rect_clip_content = true
		skinTextureRect.rect_rotation = 0
		skinIsTransitioning = false
	
	if mode == "none":
		skinTextureRect.texture = skinsInfo.skinsTexture[skinsInfo.skinsIndex[skinIndex]]
		if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]]:
			skinAlpha = 1
		else :
			skinAlpha = 0.4
		buySkinButtonIsOn = false
		buySkinButton.rect_scale = Vector2(0, 0)
		updateSkinsStats()

func setSkinAlpha(value):
	skinAlpha = value
func updateSelectedSkin():
	if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]]:
		playerStats._playerStats["selectedSkin"] = skinsInfo.skinsIndex[skinIndex]
		saveLoad.savePlayerStats()
		
		
func _process(delta):
	setColor()
	updateSelectedSkin()
	updateDiamondsLabelText()
func _ready():
	updateSkinTexture("none")
	animateTextureRect()

func updateBuySkinButton():
	buySkinButton.rect_pivot_offset = buySkinButton.rect_size / 2
	if not playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]] and buySkinButtonIsOn:
		goOutAndEnterSkinButton()
	if not playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]] and not buySkinButtonIsOn:
		enterBuySkinButton()
	if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]] and not buySkinButtonIsOn:
		pass
	if playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]] and buySkinButtonIsOn:
		goOutBuySkinButton()
	if not playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]]:
		skinPriceLabel.text = str(skinsInfo.skinsPrice[skinsInfo.skinsIndex[skinIndex]])
		
		
		
func enterBuySkinButton():
	buySkinButtonIsOn = true
	buySkinButtonTween.interpolate_property(buySkinButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), buyButtonAnimDur)
	buySkinButtonTween.start()
	
func goOutBuySkinButton():
	buySkinButtonIsOn = false
	buySkinButtonTween.interpolate_property(buySkinButton, "rect_scale", Vector2(1, 1), Vector2(0, 0), buyButtonAnimDur)
	buySkinButtonTween.start()


func goOutAndEnterSkinButton():
	buySkinButtonIsOn = true
	buySkinButtonTween.interpolate_property(buySkinButton, "rect_scale", Vector2(1, 1), Vector2(0, 0), buyButtonAnimDur / 2)
	buySkinButtonTween.start()
	yield (buySkinButtonTween, "tween_completed")
	buySkinButtonTween.interpolate_property(buySkinButton, "rect_scale", Vector2(0, 0), Vector2(1, 1), buyButtonAnimDur / 2)
	buySkinButtonTween.start()
	

func _on_rightButton_pressed():
	makeBiggerAndSmaller(rightButton, not skinIsTransitioning)
	changeIndex(1)


func _on_leftButton_pressed():
	makeBiggerAndSmaller(leftButton, not skinIsTransitioning)
	changeIndex( - 1)

	
func makeBiggerAndSmaller(button, condition = true):
	var tween
	if button == rightButton:
		tween = rightButtonTween
	if button == leftButton:
		tween = leftButtonTween
	if condition:
		button.rect_pivot_offset = button.rect_size / 2
		tween.interpolate_property(button, "rect_scale", Vector2(1, 1), Vector2(1.1, 1.1), makeButtonBiggerAndSmallerDur / 2)
		tween.start()
		yield (tween, "tween_completed")
		tween.interpolate_property(button, "rect_scale", Vector2(1.1, 1.1), Vector2(1, 1), makeButtonBiggerAndSmallerDur / 2)
		tween.start()
	
func animateTextureRect():
	skinTextureRect.rect_pivot_offset = skinTextureRect.rect_size / 2
	while animateSkin:
		skinTextureScaleTween.interpolate_property(skinTextureRect, "rect_scale", Vector2(1, 1), Vector2(0.93, 0.93), skinTexturRectAnimDur / 2)
		skinTextureScaleTween.start()
		yield (skinTextureScaleTween, "tween_completed")
		skinTextureScaleTween.interpolate_property(skinTextureRect, "rect_scale", Vector2(0.93, 0.93), Vector2(1, 1), skinTexturRectAnimDur / 2)
		skinTextureScaleTween.start()
		yield (skinTextureScaleTween, "tween_completed")
	
func changeIndex(value):
	if not skinIsTransitioning:
		var rightOrLeft
		if skinIndex + value > (skinsInfo.skinsIndex.size() - 1):
			skinIndex = 0
		elif skinIndex + value < 0:
			skinIndex = (skinsInfo.skinsIndex.size() - 1)
		else :
			skinIndex += value
		if value < 0:
			rightOrLeft = "left"
		if value > 0:
			rightOrLeft = "right"
		updateSkinTexture(rightOrLeft)


func _on_buySkinButton_pressed():
	attempToBuySkin()
	
	
	
func attempToBuySkin():
	var skin = skinsInfo.skinsIndex[skinIndex]
	if skinsInfo.skinsPrice[skin] <= playerStats._playerStats["diamondNumber"]:
		playerStats._playerStats["diamondNumber"] -= skinsInfo.skinsPrice[skin]
		unlockSkin()
		animateDiamondLabelText()
		saveLoad.savePlayerStats()
	else :
		notEnoughMoney()
		
func notEnoughMoney():
	pass
	
	
	
func unlockSkin():
	
	playerStats.unlockedSkins[skinsInfo.skinsIndex[skinIndex]] = true
	updateSkinTexture("unlock")

func animateDiamondLabelText():
	diamondNumberTween.interpolate_method(self, "setDiamondsLabelText", diamondsInfoLabelText as int, playerStats._playerStats["diamondNumber"], diamondNumberAnimDur)
	diamondNumberTween.start()
	
func setDiamondsLabelText(value):
	diamondsInfoLabelText = str(roundNumber(value, 0))
	
func roundNumber(number, decimalDigits):
	return round(number * pow(10.0, decimalDigits)) / pow(10.0, decimalDigits)
	
	
func _on_xButton_pressed():
	sceneHandler.goToMainMenu()
