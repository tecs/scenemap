tool
extends Node2D

const MODE_SQUARE = 0
const MODE_ISOMETRIC = 1

const OFFSET_DISABLED = 0
const OFFSET_X = 1
const OFFSET_Y = 2

const ORIGIN_TOP_LEFT = 0
const ORIGIN_BOTTOM_LEFT = 1
const ORIGIN_CENTER = 2

export(int, "Square", "Isometric") var mode = MODE_SQUARE setget _setMode
export(PackedScene) var sceneSet
export(Vector2) var size = Vector2(64, 64) setget _setSize
export(int, "Disabled", "Offset X", "Offset Y") var halfOffset = OFFSET_DISABLED setget _setHalfOffset
export(int, "Top Left", "Bottom Left", "Center") var tileOrigin = ORIGIN_TOP_LEFT setget _setTileOrigin
export(bool) var ySort = true setget _setEnableYSort

var sortNode = YSort.new()
var selected = false setget _setSelected

# Construct / Destruct
func _ready():
	add_child(sortNode)
	sortNode.set_sort_enabled(ySort)

# Custom draw routines
func _draw():
	if get_tree().is_editor_hint() and selected:
		draw_set_transform(Vector2(), PI/4 if mode == MODE_ISOMETRIC else 0, size / sqrt(2) if mode == MODE_ISOMETRIC else size)
		var gridSize = 100
		var gridColor = Color(1, 0.3, 0, 0.2)
		var axisColor = Color(1, 0.8, 0.5, 0.4)
		for i in range(gridSize * 2 + 1):
			draw_line(Vector2(-gridSize, i - gridSize), Vector2(gridSize, i - gridSize), gridColor)
		for i in range(gridSize * 2 + 1):
			draw_line(Vector2(i - gridSize, -gridSize), Vector2(i - gridSize, gridSize), gridColor)
		draw_line(Vector2(-gridSize, 0), Vector2(gridSize, 0), axisColor)
		draw_line(Vector2(0, -gridSize), Vector2(0, gridSize), axisColor)

# Setters
func _setMode(newMode):
	mode = newMode
	update()

func _setSize(newSize):
	size = newSize
	update()

func _setHalfOffset(newHalfOffset):
	halfOffset = newHalfOffset
	update()

func _setTileOrigin(newTileOrigin):
	tileOrigin = newTileOrigin
	update()

func _setEnableYSort(enabled):
	ySort = enabled
	if sortNode: sortNode.set_sort_enabled(enabled)

func _setSelected(newState):
	selected = newState
	update()

# Public methods
func posToMap(pos):
	if mode == MODE_ISOMETRIC:
		var ratio = size.normalized() * (1 / size.normalized().width)
		pos /= ratio
		pos = Vector2(pos.y + pos.x, pos.y - pos.x) * ratio
	pos /= size
	return pos.floor()

func mapToPos(pos):
	pos *= size
	if tileOrigin == ORIGIN_CENTER:
		pos += size / 2
	elif tileOrigin == ORIGIN_BOTTOM_LEFT:
		pos += Vector2(0, size.height)
	if mode == MODE_ISOMETRIC:
		var ratio = size.normalized() * (1 / size.normalized().width)
		pos /= ratio
		pos = Vector2(pos.x - pos.y, pos.x + pos.y) * ratio / 2
	return pos

func createTile(tileName):
	var scene = sceneSet.instance()
	var node = sceneSet.instance().get_node(tileName)
	node.get_parent().remove_child(node)
	return node

func setTile(tileName):
	if sceneSet:
		var node = createTile(tileName)
		sortNode.add_child(node)
		var mapPos = posToMap(get_local_mouse_pos())
		node.set_pos(mapToPos(mapPos))
