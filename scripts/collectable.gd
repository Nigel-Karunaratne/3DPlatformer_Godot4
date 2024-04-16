class_name Collectable
extends Node3D

var gm : GameManager
var particle = preload("res://particles/p_collectable.tscn")

func _on_area_3d_body_entered(body):
	if body is PlayerMove:
		
		# TODO - find a better way PLEASE
		var root = get_tree().get_root()
		gm = root.get_child(root.get_child_count()-1).find_child("GameManagerNode")
		gm.increment_collectable_count(self)
		
		# Set visibility of node to false and disable interactions
		# As particles need to play, cannot disable node itself
		set_visibility_and_interactivity(false)
		
		# TODO - Play sound effect?
		
		# Play Particle effect
		var p = particle.instantiate()
		add_child(p)
		p.emitting = true
		await get_tree().create_timer(0.75).timeout
		p.queue_free()
		
		# Now can fully disable node
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	else:
		return
		
func set_visibility_and_interactivity(new_visible : bool):
	$token.visible = new_visible
	$Area3D/CollisionShape3D.set_deferred("disabled", not new_visible)
	
