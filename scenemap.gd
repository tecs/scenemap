tool
extends EditorPlugin

var control = preload("control.tscn").instance()
var selection
var active

func _selection_changed():
	var selection = get_selection().get_selected_nodes()
	var shouldShow = selection.size() == 1
	if not active:
		if shouldShow:
			addControl(selection[0])
	else:
		if not shouldShow:
			removeControl()

func _ready():
	selection = get_selection()
	selection.connect("selection_changed", self, "_selection_changed")
	

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
		add_control_to_container(CONTAINER_CANVAS_EDITOR_SIDE, control)

func removeControl():
	if active:
		active.selected = false
		active.update()
		active = null
		if (control.get_parent()):
			control.get_parent().remove_child(control)
