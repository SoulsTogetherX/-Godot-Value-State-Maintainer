@tool
extends Node

const COLOR_ACCESS = preload("res://addons/value_maintainer/global_modals/color_access.gd")
const POPUP_MANAGER = preload("res://addons/value_maintainer/global_modals/popup/popup_manager.gd")

@onready var _menu_creator: Node = $"Menu Creator"
@onready var _menu_operations: Node = $"Menu Operations"

var _tree : Tree

func init(tree : Tree) -> void:
	_tree = tree
	_menu_creator.init(self)
	_menu_operations.init(self)
func create_file(valueType : int, filePath : String) -> void:
	_tree.create_file(valueType, filePath)
func sort_item(parent : TreeItem, newItem: TreeItem) -> void:
	_tree.sort_item(parent, newItem)

func _handle_mouse_click(mouse_position: Vector2, mouse_button_index: int) -> void:
	var item := _tree.get_selected()
	
	match mouse_button_index:
		MOUSE_BUTTON_RIGHT:
			_menu_creator.open_menu(mouse_position, item)
		MOUSE_BUTTON_LEFT:
			owner.open_dock(item)
func _handle_item_activated() -> void:
	var item := _tree.get_selected()
	match typeof(item.get_metadata(0)):
		TYPE_DICTIONARY:
			item.collapsed = !item.collapsed
		TYPE_PACKED_COLOR_ARRAY, TYPE_COLOR:
			owner._on_register(COLOR_ACCESS.get_path_to(item))
func _handle_menu_press(id : int) -> void:
	_menu_operations._handle_menu_press(id)
