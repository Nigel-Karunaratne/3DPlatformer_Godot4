extends Area3D

@export var velocity: float = 100

enum UsedBasis {
	BASIS_Z_MINUS,
	BASIS_Y,
}

@export var direction: UsedBasis
@export var additional_direction: Vector3 = Vector3.ZERO

func _on_body_entered(body:Node3D):
	if body is PlayerMove:
		if direction == UsedBasis.BASIS_Y:
			body.launch_player_spring((velocity * basis.y) + additional_direction)
		else:
			body.launch_player_spring((velocity * -basis.z) + additional_direction)