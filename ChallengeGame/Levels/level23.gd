extends Node

var ring = load("res://Enemies/ContainingRing/containingRing.tscn").instance()

func _ready():
	setUpRing()
	
	
func setUpRing():
	ring.desiredRadius = 350
	ring.minMoveSpeed = 200
	ring.maxMoveSpeed = 550
	ring.changeSpeedMinTime = 3
	ring.changeSpeedMaxTime = 5
	add_child(ring)

