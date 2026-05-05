extends Node2D
class_name EffectRing

var max_radius := 120.0
var lifetime := 0.35
var age := 0.0
var ring_color := Color(0.45, 0.95, 1.0)


func setup(spawn_position: Vector2, radius: float, color: Color) -> void:
	position = spawn_position
	max_radius = radius
	ring_color = color
	queue_redraw()


func _process(delta: float) -> void:
	age += delta
	if age >= lifetime:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var t := clampf(age / lifetime, 0.0, 1.0)
	var r := lerpf(12.0, max_radius, t)
	var alpha := 1.0 - t
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, Color(ring_color.r, ring_color.g, ring_color.b, alpha * 0.78), 8.0)
	draw_arc(Vector2.ZERO, r * 0.72, 0.0, TAU, 64, Color.WHITE, alpha * 3.0)
