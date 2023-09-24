extends Node



func setLanguage():
	if userConfig._userConfig["language"] != "auto":
		TranslationServer.set_locale(userConfig._userConfig["language"])
	if userConfig._userConfig["language"] == "auto":
		TranslationServer.set_locale(OS.get_locale())

