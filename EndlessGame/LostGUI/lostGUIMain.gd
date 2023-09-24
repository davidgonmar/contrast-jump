extends CanvasLayer



onready var background = $lostGUIMain / lostGUIBackground
onready var scoreLabel = $lostGUIMain / vContainer / scoreLabelMargin / vSplitter / scoreLabel
onready var scoreStringLabel = $lostGUIMain / vContainer / scoreLabelMargin / vSplitter / scoreStringLabel
onready var bestScoreLabel = $lostGUIMain / vContainer / bestScoreLabelMargin / vSplitter / bestScoreLabel
onready var bestScoreStringLabel = $lostGUIMain / vContainer / bestScoreLabelMargin / vSplitter / bestScoreStringLabel
onready var goToMenuButton = $lostGUIMain / vContainer / hContainer / goToMenuButtonMargin / goToMenuButton
onready var tryAgainButton = $lostGUIMain / vContainer / hContainer / tryAgainButtonMargin / tryAgainButton
onready var animationTween = $animationTween
onready var lostGUIMain = $lostGUIMain
onready var textTween = $textTween

var inputType = userConfig._userConfig["gameInputType"]


var totalTextAnimationTime = 1.5

var score
var bestScore

signal click

signal tryAgain
signal goToMenu
func _hide():
	lostGUIMain.hide()
	
	
func _show():
	lostGUIMain.show()
	
func _ready():
	_hide()

func setText():
	if bestScore != null and score != null:
		bestScoreStringLabel.text = tr("BEST") + ":"
		bestScoreLabel.text = str(roundNumber(bestScore, 0))
		scoreStringLabel.text = tr("SCORE") + ":"
		scoreLabel.text = str(score)
func setColors():
	background.self_modulate = changingColorBackground.oppositeColor
	scoreLabel.self_modulate = changingColorBackground.color
	bestScoreLabel.self_modulate = changingColorBackground.color
	bestScoreStringLabel.self_modulate = changingColorBackground.color
	scoreStringLabel.self_modulate = changingColorBackground.color
	goToMenuButton.self_modulate = changingColorBackground.color
	tryAgainButton.self_modulate = changingColorBackground.color
	
func _process(delta):
	setColors()
	detectClick()
	setVariablesOnProcess()
	setText()
func slideInAnimation():
	animationTween.interpolate_property(self, "offset", Vector2(0, - 2000), Vector2(0, 0), 2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	animationTween.start()
func setVariablesOnProcess():
	bestScoreLabel.rect_pivot_offset = bestScoreLabel.rect_size / 2
	if str(score).length() > 10:
		scoreLabel.get("custom_fonts/font").size = 90
	if str(bestScore).length() > 10:
		bestScoreLabel.get("custom_fonts/font").size = 90
	if str(score).length() > 15:
		scoreLabel.get("custom_fonts/font").size = 70
	if str(bestScore).length() > 15:
		bestScoreLabel.get("custom_fonts/font").size = 70
		
		
		
func getIn(_score = 100, _bestScore = 0):
	score = _score
	bestScore = _bestScore
	yield (self, "click")
	slideInAnimation()
	yield (get_tree().create_timer(0.1), "timeout")
	_show()
	yield (animationTween, "tween_all_completed")
	animateText(score, bestScore)
func detectClick():
	if Input.is_action_just_pressed("Click") and inputType == "press":
		emit_signal("click")
	if Input.is_action_just_released("Click") and inputType == "release":
		emit_signal("click")
	
func animateText(score, bestScore):
	if score > bestScore:
		makeTextBiggerAndSmaller(totalTextAnimationTime, bestScoreLabel, 1.1)
		interpolateScoreBestScore()
		
func interpolateScoreBestScore():
	textTween.interpolate_method(self, "setHighScore", bestScore, score, totalTextAnimationTime)
	textTween.start()
	
func setHighScore(value):
	bestScore = roundNumber(min(value, score), 0)
	
func makeTextBiggerAndSmaller(duration, node, zoomedAmount):
	animationTween.interpolate_property(node, "rect_scale", Vector2(1, 1), Vector2(zoomedAmount, zoomedAmount), (duration / 2), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animationTween.start()
	yield (animationTween, "tween_all_completed")
	animationTween.interpolate_property(node, "rect_scale", Vector2(zoomedAmount, zoomedAmount), Vector2(1, 1), (duration / 2), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animationTween.start()
func _on_goToMenuButton_pressed():
	emit_signal("goToMenu")


func _on_tryAgainButton_pressed():
	emit_signal("tryAgain")


func roundNumber(number, decimalDigits):
	return round(number * pow(10.0, decimalDigits)) / pow(10.0, decimalDigits)
