class_name Collectable
extends Node3D

var gm : GameManager

func _on_area_3d_body_entered(body):
	if body is PlayerMove:
		
		# TODO - find a better way PLEASE
		gm = get_tree().get_root().get_child(0).find_child("GameManagerNode")
		gm.increment_collectable_count()
		
		# TODO - Play Sound
		# TODO - Delete Collectable (and particle effect?)
		queue_free()
	else:
		return
