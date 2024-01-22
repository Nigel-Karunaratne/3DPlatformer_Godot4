extends Area3D

func _on_body_entered(body):
	if body is PlayerMove:
		var root = get_tree().get_root()
		var gm = root.get_child(root.get_child_count()-1).find_child("GameManagerNode") as GameManager
		gm.player_die()
