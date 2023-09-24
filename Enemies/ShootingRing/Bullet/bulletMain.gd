extends KinematicBody2D

onready var animTween = $animTween
onready var sprite = $bulletSprite


var velocity = Vector2(0, 0)

var moving = true
var _screenSize = screenSize._screenSize

var animTime = 0.2

func move(delta):
	if moving:
		position += velocity * delta
	
	
func setColor():
	sprite.self_modulate = changingColorBackground.oppositeColor
	

func _process(delta):
	move(delta)
	checkForDeletion()
	setColor()
	
	
func _ready():
	scale = Vector2(0, 0)
	animTween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), animTime)
	animTween.start()
	
	
	
func checkForDeletion():
	if position.x > _screenSize.x + 1000 or position.x < - 1000 or position.y > _screenSize.y + 1000 or position.y < - 5000:
		self.queue_free()

