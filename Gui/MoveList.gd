extends MarginContainer

enum SideToMove { MOVE_WHITE, MOVE_BLACK }

const MoveLine = preload("res://Gui/MoveLine.tscn")

onready var table = $ScrollContainer/Table
onready var header = $ScrollContainer/Table/Header

var moveCounter = 1
var sideToMove = MOVE_WHITE
var moves = {}
 
func _ready():
	header.set_line("Count", "White", "Black")
	var node = MoveLine.instance()
	node.set_count(moveCounter)
	table.add_child(node)
	moves[moveCounter] = node

func add_move(move):
	var cur = moves[moveCounter]
	if sideToMove == MOVE_WHITE:
		cur.set_white_move(move)
		sideToMove = MOVE_BLACK
	else:
		cur.set_black_move(move)
		moveCounter += 1
		var node = MoveLine.instance()
		node.set_count(moveCounter)
		moves[moveCounter] = node
		table.add_child(node)
		sideToMove = MOVE_WHITE

