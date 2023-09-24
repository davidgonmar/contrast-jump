extends CanvasLayer



func _ready():
	$maxLevelPopUp.rect_scale = Vector2(0, 0)
	$maxLevelPopUp.rect_pivot_offset = $maxLevelPopUp.rect_size / 2
	
	
func enter():
	$maxLevelPopUp / messageLabel.text = tr("MAX_LEVEL_REACHED")
	$popupTween.interpolate_property($maxLevelPopUp, "rect_scale", Vector2(0, 0), Vector2(1, 1), 1.5)
	$popupTween.start()
	
func setColor():
	$maxLevelPopUp / maxLevelPoupPanel.self_modulate = changingColorBackground.oppositeColor
	$maxLevelPopUp / messageLabel.self_modulate = changingColorBackground.color
	
	
func _process(delta):
	setColor()
	
