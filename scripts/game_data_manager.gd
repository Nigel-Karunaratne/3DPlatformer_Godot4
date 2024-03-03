extends Node
# make Autoload

func _ready():
	load_from_disk()

enum Levels {
	LEVEL_NULL = 0,
	LEVEL_1 = 1,
	LEVEL_2 = 2,
	LEVEL_3 = 3,
}

var data_dict = {
	'l1_t': 0,     # Best time (fastest time to complete level). Type is l%_t
	'l1_c': false, # Were all collectables gathered in one run?. Type is l%_c
}

# Empty data dictionary, can maybe load from this if no savedata found
const EMPTY_DATA_DICT = {
	'l1_t' = 0,
	'l1_c' = false,
}

func save_to_disk():
	var file = FileAccess.open("user://savedata.sav", FileAccess.WRITE)
	file.store_var(data_dict)
	file.close()


func load_from_disk():
	if FileAccess.file_exists("user://savedata.sav"):
		var file = FileAccess.open("user://savedata.sav", FileAccess.READ)
		data_dict = file.get_var()
	else:
		# Create empty save data and save to disk
		print("SAVEDATA NOT FOUND, CREATING EMPTY SAVE DATA AND SAVING IT")
		data_dict = EMPTY_DATA_DICT
		save_to_disk()
		pass

func update_level_info(level:Levels, time:int, collected_all:bool):
	if level == Levels.LEVEL_NULL:
		return
	# Get keys
	var time_key = 'l%s_t' % level #TODO - does this work?
	var collectable_key = 'l%s_c' % level
	print(time_key, collectable_key)
	# Check if need to update and if so, update
	var updated = false
	if time > data_dict[time_key]:
		data_dict[time_key] = time
		updated = true
	if not data_dict[collectable_key] and collected_all:
		data_dict[collectable_key] = true
		updated = true
	# Only save to disk if updated
	if updated:
		save_to_disk()
	return
