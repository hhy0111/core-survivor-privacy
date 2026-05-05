extends Node2D
class_name Player

var max_hp := 120.0
var hp := 120.0
var speed := 330.0
var radius := 28.0
var invuln_timer := 0.0
var face_dir := Vector2.RIGHT
var core_color := Color(0.19, 0.93, 0.72)
var core_aura_color := Color(0.15, 0.9, 1.0, 0.18)


func set_core_palette(body: Color, aura: Color) -> void:
	core_color = body
	core_aura_color = aura
	queue_redraw()


func _process(delta: float) -> void:
	invuln_timer = maxf(0.0, invuln_timer - delta)
	queue_redraw()


func move(input_vector: Vector2, delta: float) -> void:
	if input_vector.length_squared() <= 0.001:
		return
	face_dir = input_vector.normalized()
	position += face_dir * speed * delta


func take_damage(amount: float) -> bool:
	if invuln_timer > 0.0:
		return false
	hp = maxf(0.0, hp - amount)
	invuln_timer = 0.38
	queue_redraw()
	return true


func heal(amount: float) -> void:
	hp = minf(max_hp, hp + amount)
	queue_redraw()


func _draw() -> void:
	var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.008) * 0.04
	var aura_color := core_aura_color
	var body_color := core_color
	if invuln_timer > 0.0:
		body_color = Color(1.0, 0.85, 0.35)
		aura_color = Color(1.0, 0.65, 0.2, 0.22)

	draw_circle(Vector2.ZERO, (radius + 12.0) * pulse, aura_color)
	draw_circle(Vector2.ZERO, radius, Color(0.04, 0.11, 0.14))
	draw_circle(Vector2.ZERO, radius - 3.0, body_color)
	draw_arc(Vector2.ZERO, radius - 5.0, -0.4, TAU - 0.9, 48, Color(1.0, 1.0, 1.0, 0.24), 3.0)

	var eye_shift := face_dir * 3.0
	var left_eye := Vector2(-9.0, -7.0) + eye_shift
	var right_eye := Vector2(9.0, -7.0) + eye_shift
	draw_circle(left_eye, 5.2, Color.WHITE)
	draw_circle(right_eye, 5.2, Color.WHITE)
	draw_circle(left_eye + face_dir * 1.5, 2.4, Color(0.03, 0.08, 0.1))
	draw_circle(right_eye + face_dir * 1.5, 2.4, Color(0.03, 0.08, 0.1))
	draw_arc(Vector2(0.0, 4.0), 11.0, 0.2, PI - 0.2, 18, Color(0.03, 0.08, 0.1), 2.6)
