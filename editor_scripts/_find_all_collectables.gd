@tool
extends EditorScript

# Ctrl + Shift + X OR File -> Run

func _run():
	print("Starting...")
	var gm : GameManager = get_scene().find_child("GameManagerNode") as GameManager
	
#	var collectables = get_scene().get_tree().get_nodes_in_group("Collectable")
	var collectable_count : int = get_scene().get_tree().get_nodes_in_group("Collectable").size()
	gm.level_collectable_count = collectable_count
	
	
#	var game_ui : Control = get_scene().find_child("GameUIControl")
#	(game_ui.find_child("DCollectableTotalLabel", true) as Label).text = str(collectable_count)
	
#	for node in collectables:
#		(node as Collectable).gm = gm
	
	#for node in get_all_children(get_scene()):
		#if node is OmniLight3D:
		#	pass
		
		
	print("Ended. Found ", collectable_count, " collectables. The Game Manager has been updated.")
