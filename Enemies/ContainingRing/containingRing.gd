extends KinematicBody2D


onready var sprite = $sprite

var desiredRadius = 300

var target
var velocity
var direction
var safeArea:Rect2

var playerTarget

var minMoveSpeed = 100
var maxMoveSpeed = 300
var moveSpeed
var desiredMoveSpeed
var changeSpeedMinTime = 2
var changeSpeedMaxTime = 5


var colorAlpha = 1
var enterTime = 3
onready var containingPlayer = true



func setDesiredSize():
	var currentRadius = (sprite.texture.get_size().x / 2) * sprite.scale.x * scale.x
	var multAmount = desiredRadius / currentRadius
	scale *= multAmount
	
func _ready():
	detectPlayer()
	enter()
	setDesiredSize()
	calculateSafeArea()
	newTarget()
	newMoveSpeed()
	startTimer()
	
	
func startTimer():
	$speedChangeTimer.wait_time = rand_range(changeSpeedMinTime, changeSpeedMaxTime)
	$speedChangeTimer.start()
	

	
	
func calculateSafeArea():
	var _screenSize = screenSize._screenSize
	var radius = (sprite.texture.get_size().x / 2) * scale.x
	safeArea = Rect2(Vector2(radius, radius), Vector2(_screenSize.x - radius * 2, _screenSize.y - radius * 2))

	
func setColor():
	sprite.self_modulate = changingColorBackground.oppositeColor
	sprite.self_modulate.a = colorAlpha
	
	
func _process(delta):
	setColor()
	changeDir(delta)
	changeVel(delta)
	move(delta)
	checkForNewTargetNeeded()
	
func changeDir(delta):
	var desiredDirection = (target - position).normalized()
	if direction:
		direction = lerp(direction, desiredDirection, 1.5 * delta)
	else :
		direction = desiredDirection
	
func enter():
	var enterTimer = Timer.new()
	enterTimer.one_shot = true
	enterTimer.autostart = false
	enterTimer.wait_time = enterTime
	add_child(enterTimer)
	enterTimer.start()
	while enterTimer.time_left > 0.01:
		$alphaTween.interpolate_method(self, "setAlpha", 1, 0, enterTimer.time_left / 5)
		$alphaTween.start()
		yield ($alphaTween, "tween_completed")
		$alphaTween.interpolate_method(self, "setAlpha", 0, 1, enterTimer.time_left / 5)
		yield ($alphaTween, "tween_completed")
		colorAlpha = 1
		
		
	containingPlayer = false
	
	
	
func setAlpha(value):
	colorAlpha = value
	
func newMoveSpeed():
	randomize()
	desiredMoveSpeed = rand_range(minMoveSpeed, maxMoveSpeed)
	
	
func changeVel(delta):
	if not moveSpeed:
		moveSpeed = desiredMoveSpeed
	moveSpeed = lerp(moveSpeed, desiredMoveSpeed, 3 * delta)
	velocity = direction * moveSpeed
	
func move(delta):
	if not containingPlayer:
		position += velocity * delta
	if containingPlayer:
		if playerTarget:
			position = playerTarget.position

func checkForNewTargetNeeded():
	var margin = 10
	if position.distance_to(target) < margin:
		newTarget()

func detectPlayer():
	var playerGroup = get_tree().get_nodes_in_group("player")
	if playerGroup.size() == 1:
		playerTarget = playerGroup[0]

func newTarget():
	randomize()
	var corner1 = safeArea.position.x
	var corner2 = safeArea.position.x + safeArea.size.x
	var corner3 = safeArea.position.y
	var corner4 = safeArea.position.y + safeArea.size.y
	var result = Vector2(rand_range(corner1, corner2), rand_range(corner3, corner4))
	target = result


func _on_speedChangeTimer_timeout():
	newMoveSpeed()
	startTimer()
