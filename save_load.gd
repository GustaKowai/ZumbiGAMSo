extends Node
var save_path = "user://autosave.cfg"

func save():
	print("Salvei")
	var config = ConfigFile.new()
	config.set_value("upgrades","alma_comum",GameManager.alma_comum)
	config.set_value("upgrades","alma_incomum",GameManager.alma_incomum)
	config.set_value("upgrades","alma_rara",GameManager.alma_rara)
	config.set_value("upgrades","vida_max_up", GameManager.vida_max_up)
	config.set_value("upgrades","stamina_max_up", GameManager.stamina_max_up)
	config.set_value("upgrades","stamina_rege_up", GameManager.stamina_rege_up)
	config.set_value("upgrades","sword_damage_up", GameManager.sword_damage_up)
	config.set_value("upgrades","upgrade_revolver", GameManager.upgrade_revolver)
	config.set_value("upgrades","upgrade_metralhadora", GameManager.upgrade_metralhadora)
	config.set_value("upgrades","upgrade_shotgun", GameManager.upgrade_shotgun)
	config.set_value("upgrades","upgrade_magnum", GameManager.upgrade_magnum)
	config.set_value("upgrades","upgrade_bazuca", GameManager.upgrade_bazuca)
	config.save(save_path)
	
func load_data():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(save_path)
	# If the file didn't load, ignore it.
	if err != OK:
		print("Error")
		return
	# Iterate over all sections.
	print("Carreguei")
	for type in config.get_sections():
		# Fetch the data for each section.
		GameManager.alma_comum = config.get_value(type,"alma_comum")
		GameManager.alma_incomum =config.get_value(type,"alma_incomum")
		GameManager.alma_rara =config.get_value(type,"alma_rara")
		GameManager.vida_max_up = config.get_value(type, "vida_max_up")
		GameManager.stamina_max_up = config.get_value(type, "stamina_max_up")
		GameManager.stamina_rege_up = config.get_value(type, "stamina_rege_up")
		GameManager.sword_damage_up = config.get_value(type, "sword_damage_up")
		GameManager.upgrade_revolver = config.get_value(type, "upgrade_revolver")
		GameManager.upgrade_metralhadora = config.get_value(type, "upgrade_metralhadora")
		GameManager.upgrade_shotgun = config.get_value(type, "upgrade_shotgun")
		GameManager.upgrade_magnum = config.get_value(type, "upgrade_magnum")
		GameManager.upgrade_bazuca = config.get_value(type, "upgrade_bazuca")

func save_arcade():
	var config = ConfigFile.new()
	config.set_value("upgrades","alma_comum",GameManager.alma_comum)
	config.set_value("upgrades","alma_incomum",GameManager.alma_incomum)
	config.set_value("upgrades","alma_rara",GameManager.alma_rara)
	config.set_value("upgrades","vida_max_up", GameManager.vida_max_up)
