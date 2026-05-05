extends Node2D
class_name Projectile

var velocity := Vector2.ZERO
var damage := 12.0
var radius := 8.0
var ttl := 1.45
var hits_left := 1
var projectile_color := Color(0.35, 0.95, 1.0)
var hit_ids := {}


func setup(spawn_position: Vector2, direction: Vector2, hit_damage: float, speed: float, pierce: int, color: Color) -> void:
	position = spawn_position
	velocity = direction.normalized() * speed
	damage = hit_damage
	hits_left = max(1, pierce + 1)
	projectile_color = color
	rotation = direction.angle()
	queue_redraw()


func _process(delta: float) -> void:
	position += velocity * delta
	ttl -= delta
	if ttl <= 0.0:
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
	draw_circle(Vector2.ZERO, radius + 5.0, Color(projectile_color.r, projectile_color.g, projectile_color.b, 0.18))
	draw_circle(Vector2.ZERO, radius, projectile_color)
	draw_line(Vector2(-radius * 1.8, 0.0), Vector2(radius * 0.2, 0.0), Color.WHITE, 2.0)
