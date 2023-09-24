extends CanvasLayer



onready var wonGUITween = $wonGUITween
onready var wonGUIMain = $wonGUIMain
onready var wonGUIPanel = $wonGUIMain / wonGUIPanel
onready var levelLabel = $wonGUIMain / vSplitter / levelLabelMargin / levelLabel
onready var homeButton = $wonGUIMain / vSplitter / hSplitter / homeButtonContainer / homeButton
onready var nextLevelButton = $wonGUIMain / vSplitter / hSplitter / nextLevelButtonContainer / nextLevelButton
onready var diamondLabel = $wonGUIMain / vSplitter / diamondsInfo / labelMargin / diamondLabel
onready var diamondIcon = $wonGUIMain / vSplitter / diamondsInfo / diamondTextureMargin / diamondTexture
var enterTime = 0.5

func enter(level, rewardDict):
	diamondLabel.text = "+" + str(rewardDict[str(level)])
	levelLabel.text = tr("LEVEL") + " " + str(level) + "\n" + tr("COMPLETED")
	wonGUIMain.rect_pivot_offset = wonGUIMain.rect_size / 2
	wonGUITween.interpolate_property(wonGUIMain, "rect_scale", Vector2(0, 0), Vector2(1, 1), enterTime, Tween.TRANS_LINEAR)
	wonGUITween.start()


func _ready():
	makeScaleZero()
	
	
func makeScaleZero():
	wonGUIMain.rect_scale = Vector2(0, 0)
	
	
func _process(delta):
	setColor()
	
func setColor():
	wonGUIPanel.self_modulate = changingColorBackground.oppositeColor
	levelLabel.self_modulate = changingColorBackground.color
	homeButton.self_modulate = changingColorBackground.color
	nextLevelButton.self_modulate = changingColorBackground.color
	diamondIcon.self_modulate = changingColorBackground.color
	diamondLabel.self_modulate = changingColorBackground.color

func _on_homeButton_pressed():
	sceneHandler.goToMainMenu()


func _on_nextLevelButton_pressed():
	sceneHandler.newChallengeGame(playerStats._playerStats["challengeLevel"])
