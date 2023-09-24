extends CanvasLayer


onready var FPSMonitorLabel = $FPSMonitorLabel


func setProperties():
	if userConfig._userConfig["showFPS"]:
		FPSMonitorLabel.text = "FPS: " + str(Engine.get_frames_per_second())
		FPSMonitorLabel.show()
		FPSMonitorLabel.add_color_override("font_color", changingColorBackground.oppositeColor)
		FPSMonitorLabel.add_color_override("font_outline_modulate", changingColorBackground.color)
	if not userConfig._userConfig["showFPS"]:
		FPSMonitorLabel.hide()

func _process(delta):
	setProperties()
