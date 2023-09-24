extends CanvasLayer



var minHChangingVel = 0.5
var maxHChangingVel = 2

var minChangeHDirTimerWaitTime = 120
var maxChangeHDirTimerWaitTime = 300

var minChangingHVelTimerWaitTime = 10
var maxChangingHVelTimerWaitTime = 40

var isActive
var hMultiplier
var hChangingVel
var changeHDirTimer
var changeHVelTimer

var currentColorH
var currentColorS
var currentColorV

var color
var oppositeColor

func getColorSmoothly(delta):
	currentColorH += 0.005 * hMultiplier * hChangingVel * delta
	currentColorS = userConfig._userConfig["saturation"]
	currentColorV = userConfig._userConfig["brightness"]
	
	
	
func setOppositeColor():
	oppositeColor = color.inverted()

func setColor():
	color = Color.from_hsv(currentColorH, currentColorS, currentColorV)
	$colorRect.color = color
	
func checkForHExceeds():
	if currentColorH >= 1:
		currentColorH = 0 + currentColorH - 1

	
	
func activate():
	isActive = true
	
func deactivate():
	isActive = false
	
func setRandomColor():
	currentColorH = randf() * 1
	currentColorS = userConfig._userConfig["saturation"]
	currentColorV = userConfig._userConfig["brightness"]
	
	
func _process(delta):
	if isActive:
		getColorSmoothly(delta)
	checkForHExceeds()
	setColor()
	setOppositeColor()
func getRandom(minValue, maxValue):
	var result = rand_range(minValue, maxValue)
	return result
	
func _ready():
	setUpEverything()
	

func setUpEverything():
	randomize()
	hMultiplier = getOneOrNegOne()
	hChangingVel = getRandom(minHChangingVel, maxHChangingVel)
	changeHDirTimer = Timer.new()
	changeHDirTimer.wait_time = getRandom(minChangeHDirTimerWaitTime, maxChangeHDirTimerWaitTime)
	changeHDirTimer.autostart = false
	changeHDirTimer.one_shot = true
	changeHDirTimer.connect("timeout", self, "on_changeHDirTimer_timeout")
	add_child(changeHDirTimer)
	changeHDirTimer.start()
	changeHVelTimer = Timer.new()
	changeHVelTimer.wait_time = getRandom(minChangingHVelTimerWaitTime, maxChangingHVelTimerWaitTime)
	changeHVelTimer.autostart = false
	changeHVelTimer.one_shot = true
	changeHVelTimer.connect("timeout", self, "on_changeHVelTimer_timeout")
	add_child(changeHVelTimer)
	changeHVelTimer.start()
	setRandomColor()
	activate()
	
	
func getOneOrNegOne():
	var preResult = randi() % 2
	var result
	if preResult == 1:
		result = 1
	if preResult == 0:
		result = - 1
	return result

		
func on_changeHDirTimer_timeout():
	hMultiplier *= - 1
	changeHDirTimer.wait_time = getRandom(minChangeHDirTimerWaitTime, maxChangeHDirTimerWaitTime)
	changeHDirTimer.start()
	

	

func on_changeHVelTimer_timeout():
	hChangingVel = getRandom(minHChangingVel, maxHChangingVel)
	changeHVelTimer.wait_time = getRandom(minChangingHVelTimerWaitTime, maxChangingHVelTimerWaitTime)
	changeHVelTimer.start()
