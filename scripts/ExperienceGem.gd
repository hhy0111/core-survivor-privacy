extends Node2D
class_name ExperienceGem

const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const SpriteFrameHelperScript := preload("res://scripts/SpriteFrameHelper.gd")

var xp_value := 1
var radius := 9.0
var collected := false
var gem_color := Color(0.35, 0.7, 1.0)
var sprite_texture: Texture2D
var sprite_columns := 6


func setup(spawn_position: Vector2, value: int) -> void:
	position = spawn_position
	xp_value = value
	radius = 8.0 + minf(8.0, value * 0.7)
	if value >= 8:
		sprite_texture = TextureLoaderScript.load_texture("res://assets/images/normalized/xp_large_gem_sheet.png")
	else:
		sprite_texture = TextureLoaderScript.load_texture("res://assets/images/normalized/xp_blue_gem_sheet.png")
	queue_redraw()


func attract_to(target_position: Vector2, speed: float, delta: float) -> void:
	position = position.move_toward(target_position, speed * delta)
	queue_redraw()


func _draw() -> void:
	if sprite_texture != null:
		var frame := int(Time.get_ticks_msec() / 130) % sprite_columns
		var size := Vector2(radius * 3.4, radius * 3.4)
		SpriteFrameHelperScript.draw_frame_consistent_row(self, sprite_texture, sprite_columns, 1, frame, size, 0, Color.WHITE, true)
		return

	var points := PackedVector2Array([
		Vector2(0.0, -radius),
		Vector2(radius * 0.82, 0.0),
		Vector2(0.0, radius),
		Vector2(-radius * 0.82, 0.0)
	])
	draw_polygon(points, PackedColorArray([gem_color]))
	draw_polyline(points + PackedVector2Array([points[0]]), Color.WHITE, 2.0)
