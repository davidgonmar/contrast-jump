extends Node

signal loadedPlayerStats
signal showError

var playerStatsFile = "user://playerstats.json"
var encryptionPass = "z$J&F(J@Nc_fUj)nZriU7x!A%D*0-KIPdg5%kYp2s5v8y/]?!(H+MbQe=pWm+q4¡"

var userConfigFile = "user://userconfig.json"

var isError
var isLoaded


func _ready():
	isLoaded = false
	isError = false
	connect("loadedPlayerStats", self, "loadedPlayerStats")

func savePlayerStats():
	var file = File.new()
	var err = file.open_encrypted_with_pass(playerStatsFile, File.WRITE, encryptionPass)
	var playerStatsDict = {
		"playerStats":playerStats._playerStats, 
		"unlockedSkins":playerStats.unlockedSkins
	}
	if err == OK:
		file.store_var(to_json(playerStatsDict))
		file.close()

func loadPlayerStats():
	var file = File.new()
	if file.file_exists(playerStatsFile):
		var err = file.open_encrypted_with_pass(playerStatsFile, File.READ, encryptionPass)
		if err == OK:
			var playerStatsDict = parse_json(file.get_var())
			var _playerStats = playerStatsDict["playerStats"]
			var unlockedSkins = playerStatsDict["unlockedSkins"]
			var playerStatsKeys = _playerStats.keys()
			var unlockedSkinsKeys = unlockedSkins.keys()
			var playerStatsSize = _playerStats.size()
			var unlockedSkinsSize = unlockedSkins.size()
			for i in range(playerStatsSize):
				if playerStats._playerStats.has(playerStatsKeys[i]):
					playerStats._playerStats[playerStatsKeys[i]] = _playerStats[playerStatsKeys[i]]
			for i in range(unlockedSkinsSize):
				if playerStats.unlockedSkins.has(unlockedSkinsKeys[i]):
					playerStats.unlockedSkins[unlockedSkinsKeys[i]] = unlockedSkins[unlockedSkinsKeys[i]]
			emit_signal("loadedPlayerStats")
		else :
			connect("showError", self, "showError")
			emit_signal("showError")
				
	else :
		savePlayerStats()
		emit_signal("loadedPlayerStats")


func showError():
	isError = true
	
	
func loadedPlayerStats():
	isLoaded = true
	


func saveUserConfig():
	var file = File.new()
	file.open(userConfigFile, File.WRITE)
	file.store_var(to_json(userConfig._userConfig))
	file.close()
	
	
func loadUserConfig():
	var file = File.new()
	if file.file_exists(userConfigFile):
		var err = file.open(userConfigFile, File.READ)
		if err == OK:
			var userConfigDict = parse_json(file.get_var())
			var userConfigSize = userConfigDict.size()
			var userConfigKeys = userConfigDict.keys()
			for i in range(userConfigSize):
				if userConfig._userConfig.has(userConfigKeys[i]):
					userConfig._userConfig[userConfigKeys[i]] = userConfigDict[userConfigKeys[i]]
				
	else :
		saveUserConfig()
