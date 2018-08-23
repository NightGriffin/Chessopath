extends MarginContainer

enum Commands { COMMAND_CLEAR, COMMAND_INIT }

signal init_pos
signal cleal_board

const Globals = preload("res://Globals.gd")

onready var group = $PanelContainer/VBoxContainer/Selector/WR.group
onready var selector = $PanelContainer/VBoxContainer/Selector
onready var blackCB = $PanelContainer/VBoxContainer/CenterContainer/HBoxContainer/BlackCB
onready var whiteCB = $PanelContainer/VBoxContainer/CenterContainer/HBoxContainer/WhiteCB
onready var halfMoveClock = $PanelContainer/VBoxContainer/HBoxContainer/CenterContainer4/HBoxContainer/HalfMoveClock
onready var fullMoveCounter = $PanelContainer/VBoxContainer/HBoxContainer/CenterContainer2/HBoxContainer/FullMoveCounter
onready var castlings = [
		$PanelContainer/VBoxContainer/CenterContainer2/HBoxContainer2/CastlingQ,
		$PanelContainer/VBoxContainer/CenterContainer2/HBoxContainer2/CastlingK,
		$PanelContainer/VBoxContainer/CenterContainer2/HBoxContainer2/Castlingq,
		$PanelContainer/VBoxContainer/CenterContainer2/HBoxContainer2/Castlingk
		]
onready var epTarget = $PanelContainer/VBoxContainer/CenterContainer2/HBoxContainer2/EPTarget

func get_selected_piece_color():
	var b = group.get_pressed_button()
	return Globals.get_color_from_name(b.name[0])


func get_selected_piece():
	var b = group.get_pressed_button()
	return Globals.get_piece_from_name(b.name[1])


func setup_from_FEN(fen):
	var parts = fen.split(" ")
	if parts.size() != 6:
		print("Invalid FEN")
		return
	setup_side_to_move(parts[1])
	setup_castlings(parts[2])
	setup_en_passant_square(parts[3])
	setup_half_move_clock(parts[4])
	setup_full_move_counter(parts[5])


func setup_side_to_move(value):
	if value == "b":
		blackCB.pressed = true
	else:
		whiteCB.pressed = true


func setup_castlings(value):
	var castle = [false, false, false, false]
	for i in range(value.length()):
		match value[i]:
			"Q":
				castle[Globals.CASTLE_WQ] = true
			"K":
				castle[Globals.CASTLE_WK] = true
			"q":
				castle[Globals.CASTLE_BQ] = true
			"k":
				castle[Globals.CASTLE_BK] = true
	for x in range(castle.size()):
		castlings[x].set_pressed(castle[x])


func setup_en_passant_square(value):
	pass


func setup_half_move_clock(value):
	halfMoveClock.value = int(value)


func setup_full_move_counter(value):
	fullMoveCounter.value = int(value)


func _on_InitPosition_pressed():
	whiteCB.pressed = true
	fullMoveCounter.value = 1
	halfMoveClock.value = 0
	emit_signal("init_pos")


func _on_ClearAll_pressed():
	emit_signal("cleal_board")
