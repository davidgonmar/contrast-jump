extends Node



var chasingStar = load("res://Enemies/ChasingStar/chasingStar.tscn").instance()


func _ready():
	setUpChasingStar()
	
	
func setUpChasingStar():
	add_child(chasingStar)
