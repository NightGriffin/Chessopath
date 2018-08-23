extends TabContainer

signal clear_all
signal init_position
signal mode_changed(new, old)
signal move_played(uci)

onready var setup = $Setup/CenterContainer/SetupBoard
onready var moveList = $Analyze/HBoxContainer/MoveList
onready var moveListTraining = $Training/MoveList
onready var tableBase = $Analyze/HBoxContainer/TableBase
onready var dbList = $Database/CenterContainer/PanelContainer/VBoxContainer/databaseList

const Globals = preload("res://Globals.gd")

func add_move(move):
	var mode = get_current_tab()
	if mode != Globals.MODE_SETUP:
		moveList.add_move(move)
		moveListTraining.add_move(move)
		match mode:
			Globals.MODE_ANALYZE:
				tableBase.get_tablebase_from_fen(game.to_fen())
			Globals.MODE_TRAINING:
				if  game.sideToMove == Globals.COLOR_BLACK:
					tbClient.request_best_move_from_fen(game.to_fen())
					var uci = yield(tbClient, "best_move_result")
					if uci:
						emit_signal("move_played", uci)


func setup_from_FEN(fen):
	set_current_tab(Globals.MODE_SETUP)
	setup.setup_from_FEN(fen)


func get_selected_piece_color():
	return setup.get_selected_piece_color()


func get_selected_piece():
	return setup.get_selected_piece()


func _on_SetupBoard_cleal_board():
	emit_signal("clear_all")


func _on_SetupBoard_init_pos():
	emit_signal("init_position")


func _on_ModeControlPanel_tab_changed(tab):
	var prev = get_previous_tab()
	emit_signal("mode_changed", tab, prev)
	match tab:
		Globals.MODE_ANALYZE:
			tableBase.get_tablebase_from_fen(game.to_fen())


func set_database_list(list):
	dbList.clear()
	for e in list:
		dbList.add_item(e)
