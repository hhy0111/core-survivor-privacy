extends RefCounted
class_name SpriteFrameHelper

static var _region_cache := {}
static var _row_size_cache := {}


static func frame_region(texture: Texture2D, columns: int, rows: int, frame: int, row: int = 0, padding: int = 4) -> Rect2:
	if texture == null:
		return Rect2()

	columns = maxi(1, columns)
	rows = maxi(1, rows)
	frame = clampi(frame, 0, columns - 1)
	row = clampi(row, 0, rows - 1)

	var key := "%s:%d:%d:%d:%d:%d" % [str(texture.get_rid()), columns, rows, frame, row, padding]
	if _region_cache.has(key):
		return _region_cache[key]

	var image := texture.get_image()
	if image == null:
		return Rect2(Vector2.ZERO, Vector2(texture.get_width(), texture.get_height()))

	var width := image.get_width()
	var height := image.get_height()
	var x0 := clampi(int(round(float(width) * float(frame) / float(columns))), 0, width - 1)
	var x1 := clampi(int(round(float(width) * float(frame + 1) / float(columns))) - 1, x0, width - 1)
	var y0 := clampi(int(round(float(height) * float(row) / float(rows))), 0, height - 1)
	var y1 := clampi(int(round(float(height) * float(row + 1) / float(rows))) - 1, y0, height - 1)

	var min_x := x1
	var max_x := x0
	var min_y := y1
	var max_y := y0
	var found := false
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			var color := image.get_pixel(x, y)
			if color.a <= 0.04 or _is_checker_pixel(color):
				continue
			min_x = mini(min_x, x)
			max_x = maxi(max_x, x)
			min_y = mini(min_y, y)
			max_y = maxi(max_y, y)
			found = true

	var region: Rect2
	if found:
		min_x = maxi(x0, min_x - padding)
		min_y = maxi(y0, min_y - padding)
		max_x = mini(x1, max_x + padding)
		max_y = mini(y1, max_y + padding)
		region = Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x + 1, max_y - min_y + 1))
	else:
		region = Rect2(Vector2(x0, y0), Vector2(x1 - x0 + 1, y1 - y0 + 1))

	_region_cache[key] = region
	return region


static func draw_frame(canvas: CanvasItem, texture: Texture2D, columns: int, rows: int, frame: int, target_size: Vector2, row: int = 0, modulate: Color = Color.WHITE) -> Vector2:
	if canvas == null or texture == null:
		return Vector2.ZERO

	var region := frame_region(texture, columns, rows, frame, row)
	if region.size.x <= 0.0 or region.size.y <= 0.0:
		return Vector2.ZERO

	var scale := minf(target_size.x / region.size.x, target_size.y / region.size.y)
	var draw_size := region.size * scale
	canvas.draw_texture_rect_region(texture, Rect2(-draw_size * 0.5, draw_size), region, modulate)
	return draw_size


static func draw_frame_consistent_row(canvas: CanvasItem, texture: Texture2D, columns: int, rows: int, frame: int, target_size: Vector2, row: int = 0, modulate: Color = Color.WHITE, preserve_cell_pivot: bool = false) -> Vector2:
	if canvas == null or texture == null:
		return Vector2.ZERO

	var region := frame_region(texture, columns, rows, frame, row)
	if region.size.x <= 0.0 or region.size.y <= 0.0:
		return Vector2.ZERO

	var reference_size := row_reference_size(texture, columns, rows, row)
	if reference_size.x <= 0.0 or reference_size.y <= 0.0:
		reference_size = region.size

	var scale := minf(target_size.x / reference_size.x, target_size.y / reference_size.y)
	var draw_size := region.size * scale
	var draw_position := -draw_size * 0.5
	if preserve_cell_pivot:
		var cell := frame_cell_rect(texture, columns, rows, frame, row)
		var cell_center := cell.position + cell.size * 0.5
		draw_position = (region.position - cell_center) * scale
	canvas.draw_texture_rect_region(texture, Rect2(draw_position, draw_size), region, modulate)
	return draw_size


static func row_reference_size(texture: Texture2D, columns: int, rows: int, row: int = 0) -> Vector2:
	if texture == null:
		return Vector2.ZERO
	columns = maxi(1, columns)
	rows = maxi(1, rows)
	row = clampi(row, 0, rows - 1)
	var key := "%s:%d:%d:%d" % [str(texture.get_rid()), columns, rows, row]
	if _row_size_cache.has(key):
		return _row_size_cache[key]

	var max_size := Vector2.ZERO
	for frame in range(columns):
		var region := frame_region(texture, columns, rows, frame, row)
		max_size.x = maxf(max_size.x, region.size.x)
		max_size.y = maxf(max_size.y, region.size.y)
	_row_size_cache[key] = max_size
	return max_size


static func frame_cell_rect(texture: Texture2D, columns: int, rows: int, frame: int, row: int = 0) -> Rect2:
	if texture == null:
		return Rect2()
	columns = maxi(1, columns)
	rows = maxi(1, rows)
	frame = clampi(frame, 0, columns - 1)
	row = clampi(row, 0, rows - 1)
	var width := texture.get_width()
	var height := texture.get_height()
	var x0 := clampi(int(round(float(width) * float(frame) / float(columns))), 0, width - 1)
	var x1 := clampi(int(round(float(width) * float(frame + 1) / float(columns))) - 1, x0, width - 1)
	var y0 := clampi(int(round(float(height) * float(row) / float(rows))), 0, height - 1)
	var y1 := clampi(int(round(float(height) * float(row + 1) / float(rows))) - 1, y0, height - 1)
	return Rect2(Vector2(x0, y0), Vector2(x1 - x0 + 1, y1 - y0 + 1))


static func _is_checker_pixel(color: Color) -> bool:
	return false
