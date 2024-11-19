@tool
extends Object

static var pallet_accessor : Node
static var popup : Window = null
static var _cache : Dictionary

static func add_to_cache(id : String, node : Window) -> void:
	if _cache.has(id) && is_instance_valid(_cache[id]):
		_cache[id].queue_free()
	_cache[id] = node
	node.visible = false
	pallet_accessor.add_child(node)
static func remove_from_cache(id : String) -> void:
	if _cache.has(id) && is_instance_valid(_cache[id]):
		_cache[id].queue_free()
		_cache.erase(id)

static func show(id : String, editor_ref : EditorProperty, overwrite : bool = false) -> bool:
	if is_open():
		if !overwrite: return false
		hide()
	popup = _cache[id]
	popup.editor_ref = editor_ref
	popup.show()
	return true
static func hide() -> void:
	if !popup: return
	popup.hide()
static func is_open() -> bool:
	return is_instance_valid(popup) && popup != null && popup.visible
static func is_open_id(id) -> bool:
	return is_open() && popup == _cache[id]
