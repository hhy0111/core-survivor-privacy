extends Node2D
class_name Enemy

const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const SpriteFrameHelperScript := preload("res://scripts/SpriteFrameHelper.gd")

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
var sprite_texture: Texture2D
var sprite_columns := 8
var sprite_rows := 4
var sprite_scale := 0.45
var sprite_frame_sequence: Array = []


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
	sprite_columns = int(data.get("sprite_columns", sprite_columns))
	sprite_rows = int(data.get("sprite_rows", sprite_rows))
	sprite_scale = float(data.get("sprite_scale", sprite_scale))
	sprite_frame_sequence = data.get("sprite_frame_sequence", [])
	var sprite_path := str(data.get("sprite_path", ""))
	if not sprite_path.is_empty():
		sprite_texture = TextureLoaderScript.load_texture(sprite_path)
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

	var sprite_draw_size := Vector2.ZERO
	if sprite_texture != null:
		var frame_tick := int(Time.get_ticks_msec() / 140)
		var frame := frame_tick % sprite_columns
		if not sprite_frame_sequence.is_empty():
			frame = int(sprite_frame_sequence[frame_tick % sprite_frame_sequence.size()])
		var cell := Vector2(sprite_texture.get_width() / float(sprite_columns), sprite_texture.get_height() / float(sprite_rows))
		var target_size := cell * sprite_scale
		sprite_draw_size = target_size
		var modulate := Color(1.0, 1.0, 1.0, 1.0)
		if flash_timer > 0.0:
			modulate = Color(1.35, 1.35, 1.35, 1.0)
		sprite_draw_size = SpriteFrameHelperScript.draw_frame_consistent_row(self, sprite_texture, sprite_columns, sprite_rows, frame, target_size, 0, modulate, true)
	else:
		draw_circle(Vector2.ZERO, radius, Color(0.08, 0.05, 0.1))
		draw_circle(Vector2.ZERO, radius - 3.0, draw_color)
		draw_circle(Vector2(radius * 0.28, -radius * 0.22), radius * 0.16, Color(0.08, 0.02, 0.06))
		draw_circle(Vector2(radius * 0.28, radius * 0.22), radius * 0.16, Color(0.08, 0.02, 0.06))

	if hp < max_hp or enemy_type != "normal":
		var bar_width := radius * 2.0
		var hp_ratio := clampf(hp / max_hp, 0.0, 1.0)
		var bar_y := -radius - 14.0
		if sprite_draw_size != Vector2.ZERO:
			bar_y = minf(bar_y, -sprite_draw_size.y * 0.42 - 10.0)
		draw_rect(Rect2(Vector2(-bar_width * 0.5, bar_y), Vector2(bar_width, 5.0)), Color(0.07, 0.05, 0.08, 0.85))
		draw_rect(Rect2(Vector2(-bar_width * 0.5, bar_y), Vector2(bar_width * hp_ratio, 5.0)), Color(1.0, 0.28, 0.36))
