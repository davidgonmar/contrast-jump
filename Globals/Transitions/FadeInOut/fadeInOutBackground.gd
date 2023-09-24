extends CanvasLayer




onready var fadeColorRect = $fadeColorRect
onready var animationTween = $animationTween

var halfAnimationTime = 0.8
var safeAnimationTime = 0.3
onready var colorAlpha = 0 setget setColorAlpha



signal halfAnimationCompleted
signal animationCompleted

func setColorAlpha(value):
	colorAlpha = min(value, 1)

func initiateMode(mode):
	if mode == "inOut":
		colorAlpha = 0
		animationTween.remove_all()
		animationTween.interpolate_method(self, "setColorAlpha", 0, 1, halfAnimationTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		animationTween.start()
		yield (animationTween, "tween_completed")
		emit_signal("halfAnimationCompleted")
		yield (get_tree().create_timer(safeAnimationTime), "timeout")
		animationTween.interpolate_method(self, "setColorAlpha", 1, 0, halfAnimationTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		animationTween.start()
		yield (animationTween, "tween_completed")
		emit_signal("animationCompleted")
		

	
	
func syncColor():
	fadeColorRect.color = changingColorBackground.oppositeColor
	fadeColorRect.color.a = colorAlpha
	
	
func _process(delta):
	syncColor()
