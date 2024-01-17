class_name Checkpoint
extends Node3D

@export var is_level_start: bool = false

func _on_body_entered(body):
	if body is PlayerMove:
		# TODO - Find a better way PLEASE
		var gm = get_tree().get_root().get_child(0).find_child("GameManagerNode")
		if (gm as GameManager).current_checkpoint != self:
			(gm as GameManager).on_checkpoint_enter(self)
		else:
			print("DO NOTHING!")
