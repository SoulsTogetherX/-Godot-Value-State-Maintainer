@tool
extends Window

signal unregister
signal register(colorPath : String)

@onready var _tree: Tree = $"MarginContainer/Content/Dock Comunicator/Tree Container/Tree"
@onready var _color_dock: PanelContainer = $"MarginContainer/Content/Dock Comunicator/Dock Container"

func _ready() -> void:
	close_requested.connect(hide)
	_tree.nothing_selected.connect(_color_dock.hide_dock)

func _emit_closed() -> void:
	close_requested.emit()
func _on_unregister() -> void:
	unregister.emit()
	close_requested.emit()
func _on_register(value : Variant) -> void:
	register.emit(value)
	close_requested.emit()

func open_dock(item : TreeItem) -> void:
	_color_dock.open_dock(item)
func hide_dock() -> void:
	_color_dock.hide_dock()
func update_icon(item : TreeItem) -> void:
	_tree.update_icon(item)
func scan() -> void:
	_tree.scan()
