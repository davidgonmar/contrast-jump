extends Node2D

var minXVel = 10
var defaultImpulse = Vector2(550, - 650)
var defaultRotationImpulse = 18
var gravity = 2800
var maxYVel = 850
var xFriction = 0.2
var rotationFriction = 0.1
var spriteAlpha setget setSpriteAlpha, getSpriteAlpha
signal enemyHit

onready var velocity = Vector2(0, 0)
onready var rotationVelocity = 0
onready var canControl = true
onready var inputType = userConfig._userConfig["gameInputType"]
onready var canMove = true
onready var isDead = false
onready var hasWon = false

onready var _screenSize = screenSize._screenSize
onready var GUISize = 200
func setSpriteAlpha(value:float):
	spriteAlpha = min(value, 1)
	
func getSpriteAlpha():
	return spriteAlpha
	
func _ready():
	changeAndResizeSkin()
	
func goToMiddle()->void :
	position.x = _screenSize.x / 2
	position.y = _screenSize.y / 2
	

func _physics_process(delta)->void :
	pass

func _process(delta):
	getInput()
	setPlayerColor()
	movePlayer(delta)
	rotatePlayer(delta)
	decceleratePlayer(delta)
	
	
func rotatePlayer(delta)->void :
	rotation += rotationVelocity * delta



func clampPosition():
	position.y = clamp(position.y, 0, _screenSize.y)
	position.x = clamp(position.x, 0, _screenSize.x)
	
	
	
func movePlayer(delta)->void :
	if canMove:
		if canControl:
			clampPosition()
		position += (velocity * delta)
	
	
	
func decceleratePlayer(delta):
	if velocity.y < maxYVel:
		velocity.y += (gravity * delta)
	if velocity.y > maxYVel:
		velocity.y = maxYVel
	velocity.x *= pow(xFriction, delta)
	rotationVelocity *= pow(rotationFriction, delta)
	
func getInput()->void :
	var impulseDirection = null
	if isClicked():
		var mousePos = get_global_mouse_position()
		if mousePos.x > _screenSize.x / 2:
			impulseDirection = "right"
		if mousePos.x <= _screenSize.x / 2:
			impulseDirection = "left"
		applyImpulse(impulseDirection)
		

		
func isClicked():
	if Input.is_action_just_pressed("Click") and inputType == "press" and get_global_mouse_position().y > GUISize:
		return true
	if Input.is_action_just_released("Click") and inputType == "release" and get_global_mouse_position().y > GUISize:
		return true
		
func applyImpulse(impulseDirection):
	if impulseDirection == "right" and canControl:
		velocity.y = defaultImpulse.y
		velocity.x = defaultImpulse.x
		rotationVelocity = defaultRotationImpulse
		
	if impulseDirection == "left" and canControl:
		velocity.y = defaultImpulse.y
		velocity.x = - defaultImpulse.x
		rotationVelocity = - defaultRotationImpulse



func _on_playerHitbox_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("enemyHit")
		
func setPlayerColor():
	var desiredColor = changingColorBackground.oppositeColor
	desiredColor.a = spriteAlpha
	$playerSprite.self_modulate = desiredColor
	$explosionParticles.self_modulate = changingColorBackground.oppositeColor

func changeAndResizeSkin():
	$playerSprite.texture = skinsInfo.skinsTexture[playerStats._playerStats["selectedSkin"]]
	var desiredXSize = (($playerHitbox / playerHitboxShape.get_shape().radius * 2) + 2) * $playerHitbox / playerHitboxShape.scale
	var xSize = $playerSprite.texture.get_size().x
	var multRatio = desiredXSize / xSize
	$playerSprite.scale *= multRatio
	spriteAlpha = 1

func startRecuperation():
	var recuperationTime = skinsInfo.skinsStats[playerStats._playerStats["selectedSkin"]]["recuperation"]
	$playerHitbox / playerHitboxShape.set_deferred("disabled", true)
	$playerAnimationPlayer.play("recuperationTime")
	yield (get_tree().create_timer(recuperationTime), "timeout")
	$playerHitbox / playerHitboxShape.set_deferred("disabled", false)
	$playerAnimationPlayer.stop()
	setSpriteAlpha(1)
	
func die():
	isDead = true
	canMove = false
	$explosionParticles.set_emitting(true)
	canControl = false
	$playerHitbox / playerHitboxShape.set_deferred("disabled", true)
	$playerSprite.hide()
	
func win():
	hasWon = true
	canControl = false
	$playerHitbox / playerHitboxShape.set_deferred("disabled", true)
