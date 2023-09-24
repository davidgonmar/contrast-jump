extends KinematicBody2D

onready var _screenSize = screenSize._screenSize
var yVelocity = 100
var xVelocity = 0
var size

func _physics_process(delta):
	pass
	
func _ready():
	getSize()
	setCircleScale()
	
func move(delta)->void :
	position.y += yVelocity * delta
	position.x += xVelocity * delta

func getSize()->void :
		size = get_node("circleCollisionShape").get_shape().radius * 2
func deleteSelf():
	self.queue_free()

func deleteIfTooLow():
	if position.y > (_screenSize.y + 500):
		deleteSelf()

func setCircleScale():
	var texXSize = $circleSprite.texture.get_size().x
	var desiredSize = size
	var multRatio = desiredSize / texXSize
	$circleSprite.scale *= multRatio

func setCircleColor():
	var desiredColor = changingColorBackground.oppositeColor
	$circleSprite.self_modulate = desiredColor
	
func _process(delta):
	setCircleColor()
	deleteIfTooLow()
	move(delta)
