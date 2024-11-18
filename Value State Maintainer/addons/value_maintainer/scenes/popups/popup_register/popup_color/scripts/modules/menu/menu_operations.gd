@tool
extends Node

const FILENAME_VALIDATOR := preload("res://addons/value_maintainer/global_modals/filename_vaildator.gd")
const COLOR_ACCESS = preload("res://addons/value_maintainer/global_modals/color_access.gd")
const CONSTANTS := COLOR_ACCESS.CONSTANTS
const FILE_MENU = CONSTANTS.FILE_MENU

var _menu_access : Node

func init(menu_access : Node) -> void:
	_menu_access = menu_access

func _handle_menu_press(id : int) -> void:
	var selected_item : TreeItem = _menu_access._tree.get_selected()
	
	match id:
		FILE_MENU.FILE_OPEN:
			selected_item.collapsed = false
		FILE_MENU.FILE_COPY:
			var color : Color = selected_item.get_metadata(0)
			DisplayServer.clipboard_set(color.to_html(color.a != 0))
		FILE_MENU.FILE_COPY_LIGHT:
			var color : Color = selected_item.get_metadata(0)[0]
			DisplayServer.clipboard_set(color.to_html(color.a != 0))
		FILE_MENU.FILE_COPY_DARK:
			var color : Color = selected_item.get_metadata(0)[1]
			DisplayServer.clipboard_set(color.to_html(color.a != 0))
		FILE_MENU.FILE_RENAME:
			var _old_filename = COLOR_ACCESS.get_path_to(selected_item)
			_menu_access._tree.edit_selected(true)
			
			await _menu_access._tree.item_edited
			
			var path := COLOR_ACCESS.get_path_to(selected_item).split("/")
			var vaild_filename := FILENAME_VALIDATOR.vaildate_filename(
				selected_item.get_text(0),
				typeof(selected_item.get_metadata(0))
			)
			path[path.size() - 1] = vaild_filename
			
			selected_item.set_text(0, vaild_filename)
			COLOR_ACCESS.rename_color(
				"/".join(path),
				COLOR_ACCESS.get_path_to(selected_item)
			)
			
			_menu_access.sort_item(selected_item.get_parent(), selected_item)
		FILE_MENU.FILE_DUPLICATE:
			push_warning("Note: The 'duplicate' feature has not been implemented yet")
		FILE_MENU.FILE_MOVE_DUPLICATE:
			push_warning("Note: The 'move duplicate' feature has not been implemented yet")
		FILE_MENU.FILE_DELETE:
			COLOR_ACCESS.remove_color(COLOR_ACCESS.get_path_to(selected_item))
			selected_item.call_recursive("free")
			
			owner.hide_dock()
		FILE_MENU.PATH_COPY:
			DisplayServer.clipboard_set(COLOR_ACCESS.get_path_to(selected_item))
		FILE_MENU.GROUP_EXPAND_ALL:
			selected_item.set_collapsed_recursive(false)
		FILE_MENU.GROUP_COLLAPSE_ALL:
			selected_item.set_collapsed_recursive(true)
		FILE_MENU.GROUP_NEW:
			_menu_access.create_file(
				TYPE_DICTIONARY,
				COLOR_ACCESS.get_path_to(selected_item)
			)
		FILE_MENU.COLOR_NEW:
			_menu_access.create_file(
				TYPE_COLOR,
				COLOR_ACCESS.get_path_to(selected_item)
			)
		FILE_MENU.DUAL_NEW:
			_menu_access.create_file(
				TYPE_PACKED_COLOR_ARRAY,
				COLOR_ACCESS.get_path_to(selected_item)
			)
