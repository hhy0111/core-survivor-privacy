extends Control
class_name TouchStick

var active := false
var anchor := Vector2.ZERO
var current := Vector2.ZERO
var vector := Vector2.ZERO


func set_stick(is_active: bool, start_position: Vector2, current_position: Vector2, max_distance: float) -> void:
	active = is_active
	if active:
		anchor = start_position
		var offset := current_position - anchor
		if offset.length() > max_distance:
			offset = offset.normalized() * max_distance
		current = anchor + offset
		vector = offset / max_distance
	else:
		vector = Vector2.ZERO
	queue_redraw()


func _draw() -> void:
	var base := anchor
	var knob := current
	if not active:
		base = Vector2(116.0, size.y - 150.0)
		knob = base

	draw_circle(base, 64.0, Color(0.03, 0.06, 0.09, 0.34))
	draw_arc(base, 64.0, 0.0, TAU, 48, Color(0.7, 0.95, 1.0, 0.32), 4.0)
	draw_circle(knob, 30.0, Color(0.25, 0.92, 0.82, 0.45))
	draw_circle(knob, 17.0, Color(0.9, 1.0, 1.0, 0.55))
