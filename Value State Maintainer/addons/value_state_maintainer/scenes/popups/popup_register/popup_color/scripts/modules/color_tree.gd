@tool
extends Tree

@onready var _tree_creator: Node = $"Tree Creator"
@onready var _menu_access: Node = $"Menu Access"
@onready var _create_manager: Node = $"Create Manager"

func _ready() -> void:
	_tree_creator.init(self)
	_menu_access.init(self)
	
	get_node("/root/PalletAccessor").pallet_loaded.connect(_tree_creator.scan)
	_tree_creator.scan()
	
	item_mouse_selected.connect(_menu_access._handle_mouse_click)
	item_activated.connect(_menu_access._handle_item_activated)
	
	_create_manager.update_tree.connect(_tree_creator.add_item)

func scan() -> void:
	_tree_creator.scan()
func update_icon(treeItem : TreeItem) -> void:
	_tree_creator.update_icon(treeItem)
func create_file(valueType : int, filePath : String) -> void:
	_create_manager.open_popup(valueType, filePath)
func sort_item(parent : TreeItem, newItem: TreeItem) -> void:
	_tree_creator.sort_item(parent, newItem)
