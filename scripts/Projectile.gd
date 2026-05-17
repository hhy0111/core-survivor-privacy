extends Node2D
class_name Projectile

signal expired(projectile: Projectile)

const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const SpriteFrameHelperScript := preload("res://scripts/SpriteFrameHelper.gd")

var velocity := Vector2.ZERO
var damage := 12.0
var radius := 8.0
var ttl := 1.45
var hits_left := 1
var projectile_color := Color(0.35, 0.95, 1.0)
var hit_ids := {}
var sprite_texture: Texture2D
var sprite_columns := 8
var sprite_rows := 1
var sprite_size := Vector2(88.0, 42.0)
var sprite_frame_ms := 80
var projectile_kind := "bolt"
var explosion_radius := 0.0


func setup(spawn_position: Vector2, direction: Vector2, hit_damage: float, speed: float, pierce: int, color: Color, sprite_path: String = "", kind: String = "bolt", hit_radius: float = 8.0, lifetime: float = 1.45, blast_radius: float = 0.0) -> void:
	position = spawn_position
	velocity = direction.normalized() * speed
	damage = hit_damage
	hits_left = max(1, pierce + 1)
	projectile_color = color
	projectile_kind = kind
	radius = hit_radius
	ttl = lifetime
	explosion_radius = blast_radius
	match projectile_kind:
		"missile":
			sprite_columns = 9
			sprite_rows = 1
			sprite_size = Vector2(132.0, 68.0)
			sprite_frame_ms = 70
		"fragment":
			sprite_columns = 7
			sprite_rows = 1
			sprite_size = Vector2(72.0, 34.0)
			sprite_frame_ms = 65
		"bomb":
			sprite_columns = 6
			sprite_rows = 4
			sprite_size = Vector2(94.0, 94.0)
			sprite_frame_ms = 95
		"photon":
			sprite_columns = 6
			sprite_rows = 4
			sprite_size = Vector2(108.0, 58.0)
			sprite_frame_ms = 58
		_:
			sprite_columns = 8
			sprite_rows = 1
			sprite_size = Vector2(88.0, 42.0)
			sprite_frame_ms = 80
	if not sprite_path.is_empty():
		sprite_texture = TextureLoaderScript.load_texture(sprite_path)
	rotation = direction.angle()
	queue_redraw()


func _process(delta: float) -> void:
	position += velocity * delta
	ttl -= delta
	if ttl <= 0.0:
		expired.emit(self)
		queue_free()
		return
	queue_redraw()


func can_hit(enemy: Node) -> bool:
	return not hit_ids.has(enemy.get_instance_id())


func register_hit(enemy: Node) -> void:
	hit_ids[enemy.get_instance_id()] = true
	hits_left -= 1
	if hits_left <= 0:
		queue_free()


func _draw() -> void:
	if sprite_texture != null:
		var frame := int(Time.get_ticks_msec() / sprite_frame_ms) % sprite_columns
		SpriteFrameHelperScript.draw_frame_consistent_row(self, sprite_texture, sprite_columns, sprite_rows, frame, sprite_size, 0, Color.WHITE, true)
		return

	if projectile_kind == "missile":
		var flame_color := Color(1.0, 0.42, 0.12, 0.86)
		var hot_color := Color(1.0, 0.9, 0.28, 0.92)
		var body_color := Color(projectile_color.r, projectile_color.g, projectile_color.b, 1.0)
		draw_circle(Vector2(4.0, 0.0), radius * 1.55, Color(body_color.r, body_color.g, body_color.b, 0.15))
		draw_line(Vector2(-56.0, 0.0), Vector2(28.0, 0.0), Color(1.0, 0.55, 0.16, 0.26), 18.0)
		draw_line(Vector2(-36.0, 0.0), Vector2(34.0, 0.0), Color(body_color.r, body_color.g, body_color.b, 0.34), 14.0)
		draw_polygon(
			PackedVector2Array([Vector2(-58.0, 0.0), Vector2(-22.0, -14.0), Vector2(-22.0, 14.0)]),
			PackedColorArray([flame_color, hot_color, flame_color])
		)
		draw_polygon(
			PackedVector2Array([Vector2(-24.0, -18.0), Vector2(30.0, -12.0), Vector2(54.0, 0.0), Vector2(30.0, 12.0), Vector2(-24.0, 18.0)]),
			PackedColorArray([Color(0.08, 0.2, 0.28, 1.0), body_color, Color.WHITE, body_color, Color(0.08, 0.2, 0.28, 1.0)])
		)
		draw_polygon(PackedVector2Array([Vector2(-16.0, -16.0), Vector2(-40.0, -28.0), Vector2(-26.0, -4.0)]), PackedColorArray([body_color, Color(0.22, 0.72, 1.0), body_color]))
		draw_polygon(PackedVector2Array([Vector2(-16.0, 16.0), Vector2(-40.0, 28.0), Vector2(-26.0, 4.0)]), PackedColorArray([body_color, Color(0.22, 0.72, 1.0), body_color]))
		draw_line(Vector2(-8.0, -7.0), Vector2(30.0, -3.0), Color.WHITE, 3.0)
		draw_circle(Vector2(38.0, 0.0), 7.0, Color(1.0, 1.0, 1.0, 0.96))
		return

	if projectile_kind == "fragment":
		draw_circle(Vector2.ZERO, radius + 7.0, Color(projectile_color.r, projectile_color.g, projectile_color.b, 0.22))
		draw_circle(Vector2.ZERO, radius, projectile_color)
		draw_line(Vector2(-radius * 2.3, 0.0), Vector2(radius * 0.35, 0.0), Color.WHITE, 2.0)
		return

	draw_circle(Vector2.ZERO, radius + 5.0, Color(projectile_color.r, projectile_color.g, projectile_color.b, 0.18))
	draw_circle(Vector2.ZERO, radius, projectile_color)
	draw_line(Vector2(-radius * 1.8, 0.0), Vector2(radius * 0.2, 0.0), Color.WHITE, 2.0)
