@tool
extends Node

const FILENAME_VALIDATOR = preload("res://addons/value_state_maintainer/global_modals/filename_vaildator.gd")
const ICON_CREATOR = preload("res://addons/value_state_maintainer/global_modals/icon_creator.gd")
const COLOR_ACCESS := preload("res://addons/value_state_maintainer/global_modals/color_access.gd")
const CONSTANTS = COLOR_ACCESS.CONSTANTS

var _tree : Tree

func init(tree : Tree) -> void:
	_tree = tree

func scan() -> void:
	_tree.clear()
	_assign_tree_recursive(_tree.create_item(), COLOR_ACCESS.pallet, CONSTANTS.COLOR_SYSTEM_PREFIX)
	ICON_CREATOR.add_icon_to_item(_tree.get_root())
func _assign_tree_recursive(
			parent : TreeItem,
			value : Variant,
			itemName : StringName
			) -> void:
	parent.set_text(0, itemName)
	parent.set_metadata(0, value)
	ICON_CREATOR.add_icon_to_item(parent)
	
	if value is Dictionary:
		var groups : Array = []
		var other : Array = []
		for item in value.keys():
			if typeof(value[item]) == TYPE_DICTIONARY:
				groups.append(item)
				continue
			other.append(item)
		for item in groups:
			var new_item := parent.create_child()
			new_item.collapsed = true
			_assign_tree_recursive(new_item, value[item], item)
		for item in other:
			var new_item := parent.create_child()
			new_item.collapsed = true
			_assign_tree_recursive(new_item, value[item], item)

func update_icon(treeItem : TreeItem) -> void:
	ICON_CREATOR.add_icon_to_item(treeItem)
func add_item(filepath : String, value : Variant) -> void:
	var path := filepath.split("/")
	var filename : String = path[path.size() - 1]
	var parent := _tree.get_root()
	
	var group : Dictionary
	for key in path.slice(1, path.size() - 1):
		var found := false
		for item in parent.get_children():
			if key == item.get_text(0):
				parent = item
				found = true
				break
		if !found:
			push_error("Cannot add item to color-tree at invalid path location '", filepath, "'")
			return
	
	var item := parent.create_child(0)
	item.set_text(0, filename)
	item.set_metadata(0, value)
	update_icon(item)
	
	sort_item(parent, item)
	parent.collapsed = false
func sort_item(parent : TreeItem, newItem: TreeItem) -> void:
	if parent.get_child_count() <= 1: return
	
	var newFilename := newItem.get_text(0)
	var newType := typeof(newItem.get_metadata(0))
	var found := false
	
	var placeholder : TreeItem
	for search_item in parent.get_children():
		placeholder = search_item
		
		if typeof(search_item.get_metadata(0)) == newType:
			if search_item.get_text(0) > newFilename:
				found = true
				break
		elif newType == TYPE_DICTIONARY: break
	
	if !found || (parent.get_child_count() <= 2 && newType != TYPE_DICTIONARY && newItem.get_text(0) > placeholder.get_text(0)):
		newItem.move_after(placeholder)
	else:
		newItem.move_before(placeholder)
