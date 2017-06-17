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
export(bool) var ySort = false setget _setEnableYSort

var sortNode

func _draw():
	if get_tree().is_editor_hint():
		pass # draw grid
	# draw set

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
	if sortNode:
		sortNode.set_sort_enabled(enabled)
	update()

func _ready():
	sortNode = YSort.new()
	sortNode.set_sort_enabled(ySort)