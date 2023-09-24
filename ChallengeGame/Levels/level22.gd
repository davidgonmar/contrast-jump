extends Node

var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()

func _ready():
	setUpRing()
	
	
func setUpRing():
	ring.desiredRadius = 375
	ring.minMoveSpeed = 150
	ring.maxMoveSpeed = 525
	ring.changeSpeedMinTime = 2
	ring.changeSpeedMaxTime = 4
	add_child(ring)
	

