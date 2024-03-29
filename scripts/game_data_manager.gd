extends Node
# make Autoload

func _ready():
	load_from_disk()

const LEVEL_COUNT = 2

enum Levels {
	LEVEL_NULL = 0,
	LEVEL_1 = 1,
	LEVEL_2 = 2,
	LEVEL_3 = 3,
}

var data_dict = {
	'l1_t': 0,     # Best time (fastest time to complete level). Type is l%_t
	'l1_c': false, # Were all collectables gathered in one run?. Type is l%_c
	'l2_t': 0,
	'l2_c': false,
}

# Empty data dictionary, can maybe load from this if no savedata found
const EMPTY_DATA_DICT = {
	'l1_t': -1,
	'l1_c': false,
	'l2_t': -1,
	'l2_c': false,
}

const LEVEL_NAMES = ['null', "Monument 1", "Monument 2"]


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
		data_dict = EMPTY_DATA_DICT.duplicate(true)
		save_to_disk()
		pass

func update_level_info(level:Levels, time:int, collected_all:bool):
	if level == Levels.LEVEL_NULL:
		return
	# Get keys
	var time_key = 'l%s_t' % level
	var collectable_key = 'l%s_c' % level
	# Check if need to update and if so, update
	# NOTE - data_dict[time_key] < 0 means user has not cleared level before
	var updated = false
	if data_dict[time_key] < 0 or time < data_dict[time_key]:
		data_dict[time_key] = time
		updated = true
	if not data_dict[collectable_key] and collected_all:
		data_dict[collectable_key] = true
		updated = true
	# Only save to disk if updated
	if updated:
		save_to_disk()
	return

func get_level_info(level: Levels):
	if level == Levels.LEVEL_NULL:
		return
	return {
		name = LEVEL_NAMES[level],
		time = data_dict['l%s_t' % level],
		time_str = format_time(data_dict['l%s_t' % level]),
		collectable = data_dict['l%s_c' % level]
	}
	
func format_time(time):
	var minute = int(time / 60)
	var sec = time % 60
	return "%d:%02d" % [minute, sec]
