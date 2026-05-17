extends RefCounted
class_name TextureLoader

static var _cache := {}


static func load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if _cache.has(path):
		return _cache[path]

	var texture := ResourceLoader.load(path, "Texture2D") as Texture2D
	if texture == null:
		return null

	_cache[path] = texture
	return texture
