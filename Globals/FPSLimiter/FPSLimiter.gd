extends Node


func limitFPS():
	Engine.set_target_fps(userConfig._userConfig["maxFPS"])

func _process(delta):
	limitFPS()
