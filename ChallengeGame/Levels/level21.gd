extends Node

var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()

func _ready():
	setUpRing()
	
	
func setUpRing():
	ring.desiredRadius = 400
	ring.minMoveSpeed = 100
	ring.maxMoveSpeed = 400
	ring.changeSpeedMinTime = 2
	ring.changeSpeedMaxTime = 4
	add_child(ring)
	
	

