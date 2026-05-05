extends Node2D
class_name Enemy

signal died(enemy: Enemy)

var enemy_id := "drifter"
var enemy_name := "오염체"
var enemy_type := "normal"
var max_hp := 20.0
var hp := 20.0
var speed := 90.0
var damage := 10.0
var xp_value := 2
var radius := 20.0
var body_color := Color(0.9, 0.2, 0.45)
var flash_timer := 0.0
var dead := false


func setup(data: Dictionary, spawn_position: Vector2) -> void:
	enemy_id = data.get("id", enemy_id)
	enemy_name = data.get("name", enemy_name)
	enemy_type = data.get("type", enemy_type)
	max_hp = float(data.get("hp", max_hp))
	hp = max_hp
	speed = float(data.get("speed", speed))
	damage = float(data.get("damage", damage))
	xp_value = int(data.get("xp", xp_value))
	radius = float(data.get("radius", radius))
	body_color = data.get("color", body_color)
	position = spawn_position
	queue_redraw()


func update_ai(player_position: Vector2, delta: float) -> void:
	if dead:
		return
	var direction := position.direction_to(player_position)
	position += direction * speed * delta
	rotation = direction.angle()
	flash_timer = maxf(0.0, flash_timer - delta)
	queue_redraw()


func apply_damage(amount: float, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	if dead:
		return
	hp -= amount
	flash_timer = 0.08
	if knockback_direction.length_squared() > 0.001:
		position += knockback_direction.normalized() * minf(24.0, amount * 0.42)
	if hp <= 0.0:
		dead = true
		died.emit(self)
		queue_free()
	else:
		queue_redraw()


func _draw() -> void:
	var draw_color := body_color
	if flash_timer > 0.0:
		draw_color = Color.WHITE

	if enemy_type == "boss":
		draw_circle(Vector2.ZERO, radius + 12.0, Color(1.0, 0.23, 0.35, 0.18))
	elif enemy_type == "elite":
		draw_circle(Vector2.ZERO, radius + 7.0, Color(1.0, 0.85, 0.22, 0.18))

	draw_circle(Vector2.ZERO, radius, Color(0.08, 0.05, 0.1))
	draw_circle(Vector2.ZERO, radius - 3.0, draw_color)
	draw_circle(Vector2(radius * 0.28, -radius * 0.22), radius * 0.16, Color(0.08, 0.02, 0.06))
	draw_circle(Vector2(radius * 0.28, radius * 0.22), radius * 0.16, Color(0.08, 0.02, 0.06))

	if hp < max_hp or enemy_type != "normal":
		var bar_width := radius * 2.0
		var hp_ratio := clampf(hp / max_hp, 0.0, 1.0)
		draw_rect(Rect2(Vector2(-bar_width * 0.5, -radius - 14.0), Vector2(bar_width, 5.0)), Color(0.07, 0.05, 0.08, 0.85))
		draw_rect(Rect2(Vector2(-bar_width * 0.5, -radius - 14.0), Vector2(bar_width * hp_ratio, 5.0)), Color(1.0, 0.28, 0.36))
