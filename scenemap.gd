tool
extends EditorPlugin

var control = preload("control.tscn").instance()
var menu = Control.new()
var active

func _selection_changed():
	var selectedNodes = get_selection().get_selected_nodes()
	var selecton = selectedNodes[0] if selectedNodes.size() == 1 else null
	var shouldShow = selecton and selecton.get_script() and selecton.get_script().get_name() == SCRIPT_NAME
	if not active:
		if shouldShow:
			addControl(selecton)
	else:
		if selecton and not shouldShow:
			removeControl()

func _ready():
	get_selection().connect("selection_changed", self, "_selection_changed")
	

func _enter_tree():
	add_custom_type("SceneMap", "Node2D", preload("scenemap_node.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("SceneMap")
	removeControl()

func addControl(selection):
	if not active:
		active = selection
		active.selected = true
		active.update()
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, menu)
		add_control_to_container(CONTAINER_CANVAS_EDITOR_SIDE, control)

func removeControl():
	if active:
		active.selected = false
		active.update()
		active = null
		if (control.get_parent()):
			control.get_parent().remove_child(control)
		if (menu.get_parent()):
			menu.get_parent().remove_child(menu)
