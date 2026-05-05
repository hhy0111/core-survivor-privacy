extends Node2D
class_name ExperienceGem

var xp_value := 1
var radius := 9.0
var collected := false
var gem_color := Color(0.35, 0.7, 1.0)


func setup(spawn_position: Vector2, value: int) -> void:
	position = spawn_position
	xp_value = value
	radius = 8.0 + minf(8.0, value * 0.7)
	queue_redraw()


func attract_to(target_position: Vector2, speed: float, delta: float) -> void:
	position = position.move_toward(target_position, speed * delta)
	queue_redraw()


func _draw() -> void:
	var points := PackedVector2Array([
		Vector2(0.0, -radius),
		Vector2(radius * 0.82, 0.0),
		Vector2(0.0, radius),
		Vector2(-radius * 0.82, 0.0)
	])
	draw_polygon(points, PackedColorArray([gem_color]))
	draw_polyline(points + PackedVector2Array([points[0]]), Color.WHITE, 2.0)
