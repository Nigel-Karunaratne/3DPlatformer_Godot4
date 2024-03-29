extends Area3D

enum LauncherType {
	AIR,
	SPRING,
}

@export var launcher_type : LauncherType = LauncherType.AIR
@export var velocity: float = 100
@export var overwrite_velocity = false

var tween : Tween
var spring_og_speed : float

enum UsedBasis {
	BASIS_Z_MINUS,
	BASIS_Y,
}

@export var direction: UsedBasis
@export var additional_direction: Vector3 = Vector3.ZERO

func _ready():
	if launcher_type == LauncherType.AIR:
		spring_og_speed = $launcher.rotation_speed

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
		if launcher_type == LauncherType.SPRING:
			# reset player's ability to double jump
			(body as PlayerMove).can_double_jump = true
			(body as PlayerMove).launched_from_spring = true
			pass
		
		#Animate
		if tween:
			tween.kill()
		match launcher_type:
			LauncherType.AIR:
				tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SPRING)
				tween.tween_property($launcher, "rotation_speed", spring_og_speed * 15, 0.1)
				tween.tween_property($launcher, "rotation_speed", spring_og_speed, 3)
