@tool
extends EditorScript

# Ctrl + Shift + X OR File -> Run

func _run():
	print("Starting... Looking for checkpoints")
	var gm : GameManager = get_scene().find_child("GameManagerNode") as GameManager
	
	if gm == null:
		printerr("Error: Level has no GameManagerNode! Script Ended.")
		return
	
	#print(get_scene().get_tree().get_nodes_in_group("Checkpoint").size())
	print(get_scene().get_tree().get_nodes_in_group("Checkpoint"))
	var checkpoints : Array = get_scene().get_tree().get_nodes_in_group("Checkpoint")
	# gm.checkpoints = get_scene().get_tree().get_nodes_in_group("Checkpoint")
	
#	gm.checkpoints = Array(checkpoints)
	gm.checkpoints = Array()
	for chp in checkpoints:
		gm.checkpoints.append((chp as Checkpoint))
		if (chp as Checkpoint).is_level_start:
			gm.current_checkpoint = (chp as Checkpoint)
	
	print("Ended. Found ", checkpoints.size(), " checkpoints. The Game Manager has been updated, and each checkpoint has been connected.")
