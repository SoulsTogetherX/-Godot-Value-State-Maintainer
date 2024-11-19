@tool
extends Node

const ICON_CREATOR := preload("res://addons/value_state_maintainer/global_modals/icon_creator.gd")
const CONSTANTS := preload("res://addons/value_state_maintainer/global_modals/global_values.gd")
const FILE_MENU = CONSTANTS.FILE_MENU

var _menu_access : Node
var _menu : PopupMenu

func init(menu_access : Node) -> void:
	_menu_access = menu_access
	
	_menu = $"Color Menu"
	if !_menu.id_pressed.is_connected(menu_access._handle_menu_press):
		_menu.id_pressed.connect(menu_access._handle_menu_press)
	_menu.wrap_controls = true
	_menu.hide()

func open_menu(mouse_position : Vector2i, item : TreeItem) -> void:
	_init_main_menu(item)
	
	var expected_position : Vector2 = Vector2(mouse_position + owner.position) + _menu_access._tree.global_position
	var screen_rect : Rect2 = DisplayServer.screen_get_usable_rect()
	_menu.position = expected_position.max(screen_rect.position).min(screen_rect.size - _menu.get_contents_minimum_size())
	
	_menu.show()
func close_menu() -> void:
	_menu.hide()

func _init_main_menu(item : TreeItem) -> void:
	_menu.clear(true)
	var type : int = typeof(item.get_metadata(0))
	
	if type == TYPE_DICTIONARY:
		_menu.add_submenu_node_item("Create New", _init_create_menu(), FILE_MENU.FILE_NEW)
		_menu.set_item_icon(FILE_MENU.FILE_NEW, ICON_CREATOR.get_icon("Add"))
		
		_menu.add_separator()
		
		_menu.add_icon_item(ICON_CREATOR.get_icon("Load"), "Expand Group", FILE_MENU.FILE_OPEN)
		_menu.add_icon_item(ICON_CREATOR.get_icon("GuiTreeArrowDown"), "Expand Hierarchy", FILE_MENU.GROUP_EXPAND_ALL)
		_menu.add_icon_item(ICON_CREATOR.get_icon("GuiTreeArrowRight"), "Collapse Hierarchy", FILE_MENU.GROUP_COLLAPSE_ALL)
		
		_menu.add_separator()
	
	_menu.add_icon_item(ICON_CREATOR.get_icon("ActionCopy"), "Copy Path", FILE_MENU.PATH_COPY)
	
	if type == TYPE_COLOR:
		_menu.add_icon_item(ICON_CREATOR.get_icon("Droplette"), "Copy Color", FILE_MENU.FILE_COPY)
	elif type == TYPE_PACKED_COLOR_ARRAY:
		_menu.add_submenu_node_item("Copy Color", _init_color_menu(), FILE_MENU.FILE_COPY)
	_menu.add_separator()
	
	if item != _menu_access._tree.get_root():
		_menu.add_icon_item(ICON_CREATOR.get_icon("Rename"), "Rename...", FILE_MENU.FILE_RENAME)
	_menu.add_icon_item(ICON_CREATOR.get_icon("Duplicate"), "Duplicate...", FILE_MENU.FILE_DUPLICATE)
	_menu.add_icon_item(ICON_CREATOR.get_icon("MoveUp"), "Move/Duplicate to...", FILE_MENU.FILE_MOVE_DUPLICATE)
	
	if item != _menu_access._tree.get_root():
		_menu.add_icon_item(ICON_CREATOR.get_icon("Remove"), "Delete", FILE_MENU.FILE_DELETE)
	
	_menu.size = Vector2.ZERO
func _init_create_menu() -> PopupMenu:
	var sub_menu := PopupMenu.new()
	sub_menu.id_pressed.connect(_menu_access._handle_menu_press)
	sub_menu.wrap_controls = false
	
	sub_menu.add_icon_item(ICON_CREATOR.get_icon("Folder"), "Group...", FILE_MENU.GROUP_NEW)
	sub_menu.add_icon_item(ICON_CREATOR.get_icon("Circle"), "Color...", FILE_MENU.COLOR_NEW)
	sub_menu.add_icon_item(ICON_CREATOR.get_icon("DualCircle"), "Dual Color...", FILE_MENU.DUAL_NEW)
	
	return sub_menu
func _init_color_menu() -> PopupMenu:
	var sub_menu := PopupMenu.new()
	sub_menu.id_pressed.connect(_menu_access._handle_menu_press)
	sub_menu.wrap_controls = false
	
	sub_menu.add_icon_item(ICON_CREATOR.get_icon("Droplette"), "Copy Light", FILE_MENU.FILE_COPY_LIGHT)
	sub_menu.add_icon_item(ICON_CREATOR.get_icon("DropletteInverse"), "Copy Dark", FILE_MENU.FILE_COPY_DARK)
	
	return sub_menu
