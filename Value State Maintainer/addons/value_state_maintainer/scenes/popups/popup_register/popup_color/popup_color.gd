@tool
extends PopupRegister

@onready var _tree: Tree = $"MarginContainer/Content/Dock Comunicator/Tree Container/Tree"
@onready var _color_dock: PanelContainer = $"MarginContainer/Content/Dock Comunicator/Dock Container"

func _ready() -> void:
	super()
	_tree.nothing_selected.connect(_color_dock.hide_dock)

func open_dock(item : TreeItem) -> void:
	_color_dock.open_dock(item)
func hide_dock() -> void:
	_color_dock.hide_dock()
func update_icon(item : TreeItem) -> void:
	_tree.update_icon(item)
func scan() -> void:
	_tree.scan()
