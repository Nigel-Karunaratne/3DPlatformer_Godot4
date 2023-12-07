@tool
extends EditorScript

func _run():
	print("Starting...")
	var gm:GameManager = get_scene().find_child("GameManagerNode") as GameManager
	#for node in get_all_children(get_scene()):
		#if node is OmniLight3D:
		#	pass
