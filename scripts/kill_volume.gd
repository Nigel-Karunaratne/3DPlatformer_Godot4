extends Area3D

func _on_body_entered(body):
	if body is PlayerMove:
		var gm = get_tree().get_root().get_child(0).find_child("GameManagerNode") as GameManager
		gm.player_die()
