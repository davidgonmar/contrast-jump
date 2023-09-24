extends Camera2D





onready var _screenSize = screenSize._screenSize


var shakeTraumaDecay = 0.7
var maxShakeOffset = 12
var maxShakeRotation = 0.12
var maxShakeZoomOffset = 0.15

var originalXOffset = 0
var originalYOffset = 0
var originalRotation = 0
var originalZoom = 1
var i = - 1
var xOffset
var yOffset
var rotationOffset
var xZoomOffset
var yZoomOffset
var shakeTrauma

func setDefaultVars():
	shakeTrauma = 0
	xOffset = 0
	yOffset = 0
	rotationOffset = 0
	xZoomOffset = 0
	yZoomOffset = 0
	
func _ready():
	setDefaultVars()

func _process(delta):
	make_current()
	goToMiddle()
	checkForShakeTrauma(delta)
	syncCamera()
	
	
func goToMiddle():
	position = _screenSize / 2

func addShakeTrauma(amount):
	shakeTrauma = min(amount + shakeTrauma, 1)

func getRandomFromNegOneToOne():
	return rand_range( - 1, 1)
	
func decayShakeTrauma(delta):
	var amountChanged = shakeTraumaDecay * delta
	shakeTrauma = max(shakeTrauma - amountChanged, 0)
	
	
func checkForShakeTrauma(delta):
	if shakeTrauma > 0:
		shakeScreen()
		decayShakeTrauma(delta)
	if shakeTrauma <= 0:
		setDefaultVars()
		
		
func shakeScreen():
	rotating = true
	var shakePower = pow(shakeTrauma, 2)
	xOffset = maxShakeOffset * shakePower * getRandomFromNegOneToOne()
	yOffset = maxShakeOffset * shakePower * getRandomFromNegOneToOne()
	rotationOffset = maxShakeRotation * shakePower * getRandomFromNegOneToOne()
	xZoomOffset = maxShakeZoomOffset * shakePower * getRandomFromNegOneToOne()
	yZoomOffset = maxShakeZoomOffset * shakePower * getRandomFromNegOneToOne()
	
func syncCamera():
	offset.x = xOffset + originalXOffset
	offset.y = yOffset + originalYOffset
	rotation = originalRotation + rotationOffset
	zoom.x = originalZoom + xZoomOffset
	zoom.y = originalZoom + yZoomOffset

