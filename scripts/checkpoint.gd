class_name Checkpoint
extends Node3D

@export var is_level_start: bool = false
var checkpoint_ring: MeshInstance3D
@export var respawn_position_offset : Vector3
@export var can_trigger : bool = true
const ACTIVE_COLOR : Color = Color(0.0, 0.71, 0.31, 1.0) #Green
const NOT_ACTIVE_COLOR : Color = Color(1.0, 0.0, 0.0, 1.0) #Red

func _ready():
	if find_child("checkpoint_ring"):
		checkpoint_ring = $checkpoint_ring/CheckpointActive
	if checkpoint_ring:
		set_ring_color(NOT_ACTIVE_COLOR)
	pass

func _on_body_entered(body):
	if can_trigger and body is PlayerMove:
		# TODO - Find a better way PLEASE
		var root = get_tree().get_root()
		var gm = root.get_child(root.get_child_count()-1).find_child("GameManagerNode")
		if (gm as GameManager).current_checkpoint != self:
			(gm as GameManager).on_checkpoint_enter(self)
			if checkpoint_ring:
				set_ring_color(ACTIVE_COLOR)
		else:
			print("DO NOTHING!")

func reset_active_color():
	if checkpoint_ring:
		set_ring_color(NOT_ACTIVE_COLOR)

func set_ring_color(color: Color):
	checkpoint_ring.get_surface_override_material(0).set("albedo_color", color)
	checkpoint_ring.get_surface_override_material(0).set("emission", color)
	
