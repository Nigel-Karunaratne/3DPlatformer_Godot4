@tool
extends EditorScript

# Ctrl + Shift + X OR File -> Run

func _run():
	print("Starting...")

	# Get GameManager. Abort if not present
	var gm : GameManager = get_scene().find_child("GameManagerNode") as GameManager
	if gm == null:
		printerr("Error: Level has no GameManagerNode! Script Ended.")
		return

	# Get Total # of Collectable nodes in scene
	var collectable_count : int = get_scene().get_tree().get_nodes_in_group("Collectable").size()
	gm.level_collectable_count = collectable_count


#	var game_ui : Control = get_scene().find_child("GameUIControl")
#	(game_ui.find_child("DCollectableTotalLabel", true) as Label).text = str(collectable_count)

#	for node in collectables:
#		(node as Collectable).gm = gm

	print("Ended. Found ", collectable_count, " collectables. The Game Manager has been updated.")
