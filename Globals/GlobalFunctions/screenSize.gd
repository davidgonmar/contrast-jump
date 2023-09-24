extends Node2D


var _screenSize

func getScreenSize():
	_screenSize = get_viewport_rect().size
	
func _ready():
	getScreenSize()
	

