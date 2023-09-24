extends Node

var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()

func _ready():
	setUpRing()
	
	
func setUpRing():
	ring.desiredRadius = 325
	ring.minMoveSpeed = 250
	ring.maxMoveSpeed = 600
	ring.changeSpeedMinTime = 1
	ring.changeSpeedMaxTime = 3
	add_child(ring)
