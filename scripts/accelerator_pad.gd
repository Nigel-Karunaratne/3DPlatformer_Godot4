extends Node3D

var player: PlayerMove
@export var applied_force: float


func _physics_process(_delta):
	if player != null:
		player.influence_velocity = -basis.z * applied_force
		# player.velocity += -basis.z * applied_force


func _on_area_3d_body_entered(body:Node3D):
	if body is PlayerMove:
		player = (body as PlayerMove)
		player.on_accel_pad = true

func _on_area_3d_body_exited(body:Node3D):
	if body == player:
		# player.influence_velocity -= -basis.z * applied_force
		player.on_accel_pad = false
		player = null
