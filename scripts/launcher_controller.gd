extends Area3D

@export var velocity: float = 100
@export var overwrite_velocity = false

enum UsedBasis {
	BASIS_Z_MINUS,
	BASIS_Y,
}

@export var direction: UsedBasis
@export var additional_direction: Vector3 = Vector3.ZERO

func _on_body_entered(body:Node3D):
	if body is PlayerMove:
		match direction:
			UsedBasis.BASIS_Y:
				if overwrite_velocity:
					body.velocity = Vector3.ZERO
				body.launch_player_spring((velocity * basis.y))
				body.velocity += additional_direction
			UsedBasis.BASIS_Z_MINUS:
				if overwrite_velocity:
					body.velocity = Vector3.ZERO
				body.launch_player_spring((velocity * -basis.z))
				body.velocity += additional_direction