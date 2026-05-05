extends Node2D
class_name Drone

var core_owner: Node2D
var orbit_radius := 74.0
var angle := 0.0
var orbit_speed := 2.7
var level := 1
var drone_color := Color(1.0, 0.82, 0.25)


func setup(owner_node: Node2D, start_angle: float, drone_level: int) -> void:
	core_owner = owner_node
	angle = start_angle
	level = drone_level
	queue_redraw()


func update_orbit(delta: float) -> void:
	if core_owner == null:
		return
	angle += orbit_speed * delta
	position = core_owner.position + Vector2(cos(angle), sin(angle)) * orbit_radius
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, Color(0.08, 0.06, 0.02))
	draw_circle(Vector2.ZERO, 9.0, drone_color)
	draw_circle(Vector2(3.0, -3.0), 2.4, Color.WHITE)
