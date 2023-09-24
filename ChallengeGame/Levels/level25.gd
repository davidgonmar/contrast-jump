extends Node


var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()

func _ready():
	setUpRing()
	
	
func setUpRing():
	ring.desiredRadius = 325
	ring.minMoveSpeed = 250
	ring.maxMoveSpeed = 650
	ring.changeSpeedMinTime = 3
	ring.changeSpeedMaxTime = 5
	add_child(ring)
