class_name DeathUIControl
extends Control

@onready var animation_player : AnimationPlayer = $DeathUIAnimationPlayer

func _ready():
	animation_player.play("RESET")
