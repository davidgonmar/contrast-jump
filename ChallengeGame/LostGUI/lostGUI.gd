extends CanvasLayer


onready var lostGUIMain = $lostGUIMain
onready var lostGUIPanel = $lostGUIMain / lostGUIPanel
onready var lostGUITween = $lostGUITween
onready var betterLuckLabel = $lostGUIMain / vSplitter / betterLuckLabel
onready var tryAgainButton = $lostGUIMain / vSplitter / buttonSplitter / tryAgainButtonMargin / tryAgainButton
onready var homeButton = $lostGUIMain / vSplitter / buttonSplitter / homeButtonMargin / homeButton
var enterTime = 0.5


signal click
func _ready():
		lostGUIMain.rect_scale = Vector2(0, 0)
	
	
func enter(level):
	yield (self, "click")
	lostGUIMain.rect_pivot_offset = lostGUIMain.rect_size / 2
	lostGUITween.interpolate_property(lostGUIMain, "rect_scale", Vector2(0, 0), Vector2(1, 1), enterTime, Tween.TRANS_LINEAR)
	lostGUITween.start()


func detectClick():
	if Input.is_action_pressed("Click"):
		emit_signal("click")
func _process(delta):
	setColor()
	setText()
	detectClick()
	
	
func setColor():
	betterLuckLabel.self_modulate = changingColorBackground.color
	lostGUIPanel.self_modulate = changingColorBackground.oppositeColor
	tryAgainButton.self_modulate = changingColorBackground.color
	homeButton.self_modulate = changingColorBackground.color


func setText():
	betterLuckLabel.text = tr("BETTER_LUCK")


func _on_tryAgainButton_pressed():
	sceneHandler.newChallengeGame(playerStats._playerStats["challengeLevel"])


func _on_homeButton_pressed():
	sceneHandler.goToMainMenu()
