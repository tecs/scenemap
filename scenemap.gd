tool
extends EditorPlugin

const SCRIPT_NAME = "_Scene_Map_Node_Script_"

var control = preload("control.tscn").instance()
var menu = Control.new()
var active

# Construct / Destruct
func _enter_tree():
	var script = preload("scenemap_node.gd")
	script.set_name(SCRIPT_NAME)
	add_custom_type("SceneMap", "Node2D", script, preload("icon.png"))
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
	
	var tileContainer = control.get_node("Panel/ItemList")
	tileContainer.clear()
	if active.sceneSet:
		for tile in active.sceneSet.instance().get_children():
			tileContainer.add_item(tile.get_name())

func handles(object):
	return object.get_script() and object.get_script().get_name() == SCRIPT_NAME

func forward_input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			var tilesContainer = control.get_node("Panel/ItemList")
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
