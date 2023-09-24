extends KinematicBody2D


onready var generalTween = $generalTween
onready var shootingNode = $shootingNode
onready var parentNode = $parentNode
onready var shootingRingSprite = $shootingRingSprite


onready var _screenSize = screenSize._screenSize
var progress
var bullet = load("res://Enemies/ShootingRing/Bullet/bulletMain.tscn")

var isActive = true
var state
var playerTarget
var attackDir
var bulletInstance

var minimunIdleTime = 0
var maximunIdleTime = 0
var bulletMaxVel = 50
var bulletMinVel = 10
var totalAttackTime = 0.3

var enterTime = 2.5

enum ringStates{
	entering = 0, 
	searchingForPlayer = 1, 
	idle = 2, 
	attacking = 3, 
	goingOut = 4, 
}

func progressInRange(minV, maxV):
	if progress >= minV and progress < maxV:
		return true
	else :
		return false
	
func setDiff():
	if progressInRange(0, 25):
		minimunIdleTime = 0
		maximunIdleTime = 0
		bulletMinVel = 10
		bulletMaxVel = 700
		totalAttackTime = 0.8
	if progressInRange(25, 50):
		minimunIdleTime = 0
		maximunIdleTime = 0
		bulletMinVel = 10
		bulletMaxVel = 725
		totalAttackTime = 0.65
	if progressInRange(50, 75):
		minimunIdleTime = 0
		maximunIdleTime = 0
		bulletMinVel = 10
		bulletMaxVel = 750
		totalAttackTime = 0.5
	if progressInRange(75, 100):
		minimunIdleTime = 0
		maximunIdleTime = 0
		bulletMinVel = 10
		bulletMaxVel = 800
		totalAttackTime = 0.35



func detectProgress():
	if get_parent().get_parent().has_method("getProgress"):
		progress = get_parent().get_parent().getProgress()
		
func _process(delta):
	detectDirection()
	rotateToPlayer()
	setColor()
	detectProgress()
	setDiff()
	
func setColor():
	shootingRingSprite.self_modulate = changingColorBackground.oppositeColor

func detectDirection():
	if playerTarget != null:
		attackDir = (playerTarget.position - self.position).normalized()
		
		
func _ready():
	enter()
	
	
func rotateToPlayer():
	if attackDir != null:
		shootingNode.rotation = attackDir.angle()
	if bulletInstance != null:
		bulletInstance.rotation_degrees = shootingNode.rotation_degrees - 90
	
func enter():
	isActive = true
	state = ringStates.entering
	generalTween.interpolate_property(self, "position", Vector2(_screenSize.x / 2, - 300), _screenSize / 2, enterTime)
	generalTween.start()
	yield (generalTween, "tween_completed")
	detectPlayer()
	
	
func detectPlayer():
	if isActive:
		state = ringStates.searchingForPlayer
		var playerGroup = get_tree().get_nodes_in_group("player")
		if playerGroup.size() == 1:
			playerTarget = playerGroup[0]
			getIdle()
			
			
func getIdle():
	randomize()
	state = ringStates.idle
	yield (get_tree().create_timer(rand_range(minimunIdleTime, maximunIdleTime)), "timeout")
	attack()
	
	
func attack():
	if playerTarget != null and not playerTarget.isDead and not playerTarget.hasWon:
		state = ringStates.attacking
		bulletInstance = bullet.instance()
		bulletInstance.animTime = totalAttackTime
		parentNode.add_child(bulletInstance)
		bulletInstance.global_position = shootingNode.global_position
		generalTween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.8, 0.8), totalAttackTime / 2)
		generalTween.start()
		yield (generalTween, "tween_completed")
		generalTween.interpolate_property(self, "scale", Vector2(0.8, 0.8), Vector2(1, 1), totalAttackTime / 2)
		generalTween.start()
		yield (generalTween, "tween_completed")
		bulletInstance.velocity = attackDir * rand_range(bulletMinVel, bulletMaxVel)
		bulletInstance = null
		getIdle()
	

