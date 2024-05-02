class_name Gravity3D
extends Node

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var grav_vel: Vector3 # Gravity velocity 

func apply_gravity(body: CharacterBody3D, delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if body.is_on_floor() else grav_vel.move_toward(Vector3(0, body.velocity.y - gravity, 0), gravity * delta)
	return grav_vel
