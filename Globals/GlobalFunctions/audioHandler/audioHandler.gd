extends Node

onready var musicPlayer = $musicPlayer


func playMusic():
	musicPlayer.stream = load("res://Resources/Music/aetherTheories.ogg")
	musicPlayer.play()
	
	
func checkForNoSound():
		musicPlayer.stream_paused = not userConfig._userConfig["music"]


func _process(delta):
	checkForNoSound()
