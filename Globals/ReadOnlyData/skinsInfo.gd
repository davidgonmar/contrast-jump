extends Node





var skinsIndex = [
	"doubleSquare", 
	"ghost", 
	]

var skinsTexture = {
	"doubleSquare":load("res://Resources/Textures/whiteDoubleSquare.png"), 
	"ghost":load("res://Resources/Textures/ghostSkin.png")
}

var skinsPrice = {
	"doubleSquare":0, 
	"ghost":1500, 
}

var skinsStats = {
	"doubleSquare":{
		"multiplier":1, 
		"lives":3, 
		"recuperation":1
	}, 
	"ghost":{
		"multiplier":1, 
		"lives":3, 
		"recuperation":1.5, 
	}, 
}
