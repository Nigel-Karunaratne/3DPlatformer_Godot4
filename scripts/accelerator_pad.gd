extends Node3D

var player: PlayerMove
@export var applied_force: float


func _physics_process(_delta):
	if player != null:
		player.velocity += -basis.z * applied_force


func _on_area_3d_body_entered(body:Node3D):
	if body is PlayerMove:
		player = (body as PlayerMove)

func _on_area_3d_body_exited(body:Node3D):
	if body == player:
		player = null
