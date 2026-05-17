extends Node2D
class_name Drone

const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const SpriteFrameHelperScript := preload("res://scripts/SpriteFrameHelper.gd")

var core_owner: Node2D
var orbit_radius := 74.0
var angle := 0.0
var orbit_speed := 2.7
var level := 1
var drone_color := Color(1.0, 0.82, 0.25)
var sprite_texture: Texture2D
var sprite_columns := 6
var sprite_rows := 3
var sprite_size := Vector2(76.0, 54.0)
var drone_kind := "purify"
var can_attack := true


func setup(owner_node: Node2D, start_angle: float, drone_level: int, sprite_path: String = "res://assets/images/normalized/drone_purify_sheet.png", kind: String = "purify", attacks: bool = true) -> void:
	core_owner = owner_node
	angle = start_angle
	level = drone_level
	drone_kind = kind
	can_attack = attacks
	sprite_texture = TextureLoaderScript.load_texture(sprite_path)
	sprite_rows = 4 if kind != "purify" else 3
	queue_redraw()


func update_orbit(delta: float) -> void:
	if core_owner == null:
		return
	angle += orbit_speed * delta
	position = core_owner.position + Vector2(cos(angle), sin(angle)) * orbit_radius
	queue_redraw()


func _draw() -> void:
	if sprite_texture != null:
		var frame := int(Time.get_ticks_msec() / 130) % sprite_columns
		SpriteFrameHelperScript.draw_frame_consistent_row(self, sprite_texture, sprite_columns, sprite_rows, frame, sprite_size, 0, Color.WHITE, true)
		return
	draw_circle(Vector2.ZERO, 12.0, Color(0.08, 0.06, 0.02))
	draw_circle(Vector2.ZERO, 9.0, drone_color)
	draw_circle(Vector2(3.0, -3.0), 2.4, Color.WHITE)
