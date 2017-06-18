tool
extends EditorPlugin

const SCRIPT_NAME = "_Scene_Map_Node_Script_"

var control = VBoxContainer.new()
var menu = HBoxContainer.new()
var active

# Construct / Destruct
func _enter_tree():
	var script = preload("scenemap_node.gd")
	script.set_name(SCRIPT_NAME)
	add_custom_type("SceneMap", "Node2D", script, preload("icon.png"))
	var items = ItemList.new()
	items.set_v_size_flags(ItemList.SIZE_EXPAND_FILL)
	items.set_custom_minimum_size(Vector2(80, 0))
	items.set_max_columns(0)
	items.set_icon_mode(ItemList.ICON_MODE_TOP)
	items.set_max_text_lines(2)
	items.set_name("Items")
	control.add_child(items)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, menu)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_SIDE, control)
	menu.hide()
	control.hide()

func _exit_tree():
	remove_custom_type("SceneMap")
	if control and control.get_parent(): control.get_parent().remove_child(control)
	if menu and menu.get_parent(): menu.get_parent().remove_child(menu)

# Handlers
func edit(object):
	active = object
	active.selected = true
	active.update()
	
	var tileContainer = control.get_node("Items")
	tileContainer.clear()
	if active.sceneSet:
		for tile in active.sceneSet.instance().get_children():
			tileContainer.add_item(tile.get_name())

func handles(object):
	return object.get_script() and object.get_script().get_name() == SCRIPT_NAME

func forward_input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			var tilesContainer = control.get_node("Items")
			var selected = tilesContainer.get_selected_items()
			if selected.size(): active.setTile(tilesContainer.get_item_text(selected[0]))
			return true
		elif event.button_index == BUTTON_RIGHT:
			active.unsetTile()
			return true
	return false

func make_visible(visible):
	if visible:
		menu.show()
		control.show()
	else:
		control.hide()
		menu.hide()
		if active:
			active.selected = false
			active.update()
			active = null
