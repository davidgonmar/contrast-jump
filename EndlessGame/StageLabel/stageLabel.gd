extends CanvasLayer


onready var stageLabel = $stageLabel
onready var scaleTween = $scaleTween


var animationTime = 0.5
var waitTime = 2


func setColor():
	stageLabel.add_color_override("font_color", changingColorBackground.oppositeColor)
	stageLabel.add_color_override("font_outline_modulate", changingColorBackground.color)

func _process(delta):
	setColor()
	
func _ready():
	makeScaleZero()
	
	
func makeScaleZero():
	stageLabel.rect_pivot_offset = stageLabel.rect_size / 2
	scaleTween.interpolate_property(stageLabel, "rect_scale", Vector2(0, 0), Vector2(0, 0), 0)
	scaleTween.start()
	
func enter(stage):
	stageLabel.text = tr("STAGE_" + str(stage))
	scaleTween.interpolate_property(stageLabel, "rect_scale", Vector2(0, 0), Vector2(1, 1), animationTime)
	scaleTween.start()
	yield (scaleTween, "tween_completed")
	yield (get_tree().create_timer(waitTime), "timeout")
	scaleTween.interpolate_property(stageLabel, "rect_scale", Vector2(1, 1), Vector2(0, 0), animationTime)
	scaleTween.start()
