extends Node


var shootingRing = load("res://Enemies/ShootingRing/shootingRingMain.tscn").instance()
func _ready():
	setUpChasingStar()
	
	
func setUpChasingStar():
	add_child(shootingRing)
