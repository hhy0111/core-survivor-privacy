extends Node2D
class_name SpriteSheetEffect

const TextureLoaderScript := preload("res://scripts/TextureLoader.gd")
const SpriteFrameHelperScript := preload("res://scripts/SpriteFrameHelper.gd")

var texture: Texture2D
var columns := 1
var rows := 1
var draw_size := Vector2(128.0, 128.0)
var duration := 0.42
var age := 0.0
var tint := Color.WHITE


func setup(spawn_position: Vector2, sprite_path: String, sheet_columns: int, sheet_rows: int, target_size: Vector2, effect_duration: float, modulate_color: Color = Color.WHITE) -> void:
	position = spawn_position
	texture = TextureLoaderScript.load_texture(sprite_path)
	columns = maxi(1, sheet_columns)
	rows = maxi(1, sheet_rows)
	draw_size = target_size
	duration = maxf(0.05, effect_duration)
	tint = modulate_color
	queue_redraw()


func _process(delta: float) -> void:
	age += delta
	if age >= duration:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	if texture == null:
		return

	var total_frames := maxi(1, columns * rows)
	var frame_index := clampi(int(floor((age / duration) * float(total_frames))), 0, total_frames - 1)
	var frame := frame_index % columns
	var row := int(frame_index / columns)
	var fade := 1.0 - clampf(age / duration, 0.0, 1.0)
	var color := Color(tint.r, tint.g, tint.b, tint.a * minf(1.0, fade + 0.32))
	SpriteFrameHelperScript.draw_frame_consistent_row(self, texture, columns, rows, frame, draw_size, row, color, true)
