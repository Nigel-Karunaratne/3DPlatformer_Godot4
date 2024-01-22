class_name Collectable
extends Node3D

var gm : GameManager

func _on_area_3d_body_entered(body):
	if body is PlayerMove:
		
		# TODO - find a better way PLEASE
		var root = get_tree().get_root()
		gm = root.get_child(root.get_child_count()-1).find_child("GameManagerNode")
		gm.increment_collectable_count(self)
		
		# TODO - Play Sound
		# TODO - Delete Collectable (and particle effect?)
		#queue_free()
	else:
		return
