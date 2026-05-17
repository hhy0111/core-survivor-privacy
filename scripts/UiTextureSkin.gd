extends Control

var texture: Texture2D
var source_rect := Rect2()
var tint := Color.WHITE
var slice_margins := Vector4.ZERO


func _draw() -> void:
	if texture == null:
		return

	var region := source_rect
	if region.size.x <= 0.0 or region.size.y <= 0.0:
		region = Rect2(Vector2.ZERO, Vector2(texture.get_width(), texture.get_height()))

	if slice_margins == Vector4.ZERO:
		draw_texture_rect_region(texture, Rect2(Vector2.ZERO, size), region, tint)
		return

	_draw_nine_slice(region)


func _draw_nine_slice(region: Rect2) -> void:
	var left := clampf(slice_margins.x, 0.0, region.size.x * 0.45)
	var top := clampf(slice_margins.y, 0.0, region.size.y * 0.45)
	var right := clampf(slice_margins.z, 0.0, region.size.x * 0.45)
	var bottom := clampf(slice_margins.w, 0.0, region.size.y * 0.45)

	var dst_left := minf(size.x * (left / region.size.x), size.x * 0.45)
	var dst_top := minf(size.y * (top / region.size.y), size.y * 0.45)
	var dst_right := minf(size.x * (right / region.size.x), size.x * 0.45)
	var dst_bottom := minf(size.y * (bottom / region.size.y), size.y * 0.45)

	var src_x := [region.position.x, region.position.x + left, region.end.x - right, region.end.x]
	var src_y := [region.position.y, region.position.y + top, region.end.y - bottom, region.end.y]
	var dst_x := [0.0, dst_left, size.x - dst_right, size.x]
	var dst_y := [0.0, dst_top, size.y - dst_bottom, size.y]

	for yi in range(3):
		for xi in range(3):
			var src_rect := Rect2(Vector2(src_x[xi], src_y[yi]), Vector2(src_x[xi + 1] - src_x[xi], src_y[yi + 1] - src_y[yi]))
			var dst_rect := Rect2(Vector2(dst_x[xi], dst_y[yi]), Vector2(dst_x[xi + 1] - dst_x[xi], dst_y[yi + 1] - dst_y[yi]))
			if src_rect.size.x > 0.0 and src_rect.size.y > 0.0 and dst_rect.size.x > 0.0 and dst_rect.size.y > 0.0:
				draw_texture_rect_region(texture, dst_rect, src_rect, tint)
