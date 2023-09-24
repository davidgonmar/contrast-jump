extends KinematicBody2D



var rotationVelocity = 8



var moveSpeed = 200
var dashSpeed = 2100
var preparingForDashSpeed = 50
var timeOnWall = 0.6
var dashPreparationTime = 1.75
var enterDuration = 2.5
var minChaseTime = 1.25
var maxChaseTime = 3
var goOutDuration = 2.5


onready var arrowAlpha = 0
onready var isActive = true
onready var isCurrentlyActive = false
var direction
var playerTarget
var currentSpeed
var dashDirection

var state

var progress

signal crashedOnWall


enum starStates{
	searchingForPlayer = 0, 
	chasingPlayer = 1, 
	preparingForDash = 2, 
	dashing = 3, 
	crashed = 4, 
	entering = 5, 
	goingOut = 6, 
	idle = 7, 
	
	
}
func checkForEnteringOrGoingOut():
	if isActive and not isCurrentlyActive:
		enter()
	if not isActive and isCurrentlyActive:
		goOut()
		
		
		
func checkForPlayerHasWon():
	if playerTarget != null and playerTarget.hasWon:
		isActive = false

func goOut():
	isCurrentlyActive = false
	state = starStates.goingOut
	$generalTween.interpolate_property(self, "position", position, Vector2(screenSize._screenSize.x / 2, - 200), goOutDuration)
	$generalTween.start()
	$arrowTween.stop_all()
	arrowAlpha = 0
	
func enter():
	isCurrentlyActive = true
	arrowAlpha = 0
	position = Vector2(screenSize._screenSize.x / 2, - 200)
	state = starStates.entering
	$generalTween.interpolate_property(self, "position", Vector2(screenSize._screenSize.x / 2, - 200), Vector2(screenSize._screenSize.x / 2, 300), enterDuration)
	$generalTween.start()
	yield ($generalTween, "tween_completed")
	detectPlayer()
	
	
func detectPlayer():
	if isActive:
		state = starStates.searchingForPlayer
		var playerGroup = get_tree().get_nodes_in_group("player")
		if playerGroup.size() == 1:
			playerTarget = playerGroup[0]
			chasePlayer()

func changeDirection():
	match state:
		starStates.searchingForPlayer:
			direction = Vector2(0, 0)
		starStates.chasingPlayer:
			direction = (playerTarget.position - self.position).normalized()
		starStates.preparingForDash:
			direction = (playerTarget.position - self.position).normalized()
		starStates.dashing:
			direction = dashDirection
		starStates.crashed:
			direction = Vector2(0, 0)
		starStates.entering:
			direction = Vector2(0, 0)
		starStates.goingOut:
			direction = Vector2(0, 0)
		_:
			direction = Vector2(0, 0)

func rotateStar(delta):
	$chasingStarSprite.rotation += rotationVelocity * delta

func setColor():
	$chasingStarSprite.self_modulate = changingColorBackground.oppositeColor
	$arrowNode / arrowSprite.self_modulate = changingColorBackground.oppositeColor
	$arrowNode / arrowSprite.self_modulate.a = arrowAlpha
	
func rotateArrow():
	$arrowNode.rotation = direction.angle()
	
	
func progressInRange(minV, maxV):
	if progress and progress >= minV and progress < maxV:
		return true
	else :
		return false
	
func setDiff():
	if progressInRange(0, 20):
		moveSpeed = 225
		dashSpeed = 2300
		preparingForDashSpeed = 50
		maxChaseTime = 3
	if progressInRange(20, 40):
		moveSpeed = 250
		dashSpeed = 2500
		preparingForDashSpeed = 60
		maxChaseTime = 2.5
	if progressInRange(40, 60):
		moveSpeed = 275
		dashSpeed = 2700
		preparingForDashSpeed = 80
		maxChaseTime = 2.1
	if progressInRange(60, 80):
		moveSpeed = 300
		dashSpeed = 2900
		preparingForDashSpeed = 90
		maxChaseTime = 1.75
	if progressInRange(80, 100):
		moveSpeed = 325
		dashSpeed = 3100
		preparingForDashSpeed = 100
		maxChaseTime = 1.25
			
func detectProgress():
	if get_parent().get_parent() and get_parent().get_parent().has_method("getProgress"):
		progress = get_parent().get_parent().getProgress()
		
func _process(delta):
	checkForEnteringOrGoingOut()
	changeDirection()
	changeSpeed()
	move(delta)
	rotateStar(delta)
	setColor()
	checkForWallCrash()
	detectProgress()
	setDiff()
	rotateArrow()
	checkForPlayerHasWon()
	
	
	
func checkForWallCrash():
	if position.x >= screenSize._screenSize.x or position.y >= screenSize._screenSize.y or position.x <= 0 or position.y <= 0:
		emit_signal("crashedOnWall")
		
		
		
func _ready():
	position = Vector2(screenSize._screenSize.x / 2, - 200)

	
		
		
func move(delta):
	var _position = position + currentSpeed * delta * direction
	if state != starStates.entering and starStates.goingOut:
		_position = clampPos(_position)
	position = _position

func clampPos(_position):
	_position.x = clamp(_position.x, 0, screenSize._screenSize.x)
	_position.y = clamp(_position.y, 0, screenSize._screenSize.y)
	return _position
func changeSpeed():
	match state:
		starStates.searchingForPlayer:
			currentSpeed = 0
		starStates.chasingPlayer:
			currentSpeed = moveSpeed
		starStates.preparingForDash:
			currentSpeed = preparingForDashSpeed
		starStates.dashing:
			currentSpeed = dashSpeed
		starStates.crashed:
			currentSpeed = 0
		starStates.entering:
			currentSpeed = 0
		starStates.goingOut:
			currentSpeed = 0
		_:
			currentSpeed = 0

func setArrowAlpha(value):
	arrowAlpha = min(1, value)
	arrowAlpha = max(arrowAlpha, 0)
	
	
func prepareForDash():
	if isActive and playerTarget != null and not playerTarget.isDead:
		state = starStates.preparingForDash
		arrowAlpha = 1.0
		var timer = Timer.new()
		timer.wait_time = dashPreparationTime
		timer.one_shot = true
		add_child(timer)
		timer.start()
		while not timer.is_stopped():
			$arrowTween.interpolate_method(self, "setArrowAlpha", 0, 1, timer.get_time_left() / 5)
			$arrowTween.start()
			yield ($arrowTween, "tween_completed")
		$arrowTween.stop_all()
		dashDirection = (playerTarget.position - self.position).normalized()
		remove_child(timer)
		timer.queue_free()
		dash()
	
func dash():
	if isActive and playerTarget != null and not playerTarget.isDead and not playerTarget.hasWon:
		state = starStates.dashing
		arrowAlpha = 0
		yield (self, "crashedOnWall")
		cameraMain.addShakeTrauma(0.4)
		crash()
	
func crash():
	if isActive and playerTarget != null and not playerTarget.isDead and not playerTarget.hasWon:
		state = starStates.crashed
		arrowAlpha = 0
		yield (get_tree().create_timer(timeOnWall), "timeout")
		chasePlayer()
	
func chasePlayer():
	if isActive and playerTarget != null and not playerTarget.isDead and not playerTarget.hasWon:
		state = starStates.chasingPlayer
		arrowAlpha = 0
		var timer = Timer.new()
		timer.wait_time = rand_range(minChaseTime, maxChaseTime)
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield (timer, "timeout")
		remove_child(timer)
		timer.queue_free()
		prepareForDash()
	
