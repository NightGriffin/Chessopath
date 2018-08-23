extends VBoxContainer

const Gb = preload("res://Globals.gd")

var mode

onready var menuBar = $MenuBar
onready var board = $HBoxContainer/CenterContainer/ViewportContainer/Viewport/Chessboard
onready var ctrlPanel = $HBoxContainer/VBoxContainer/ModeControlPanel
onready var vpCtrl = $HBoxContainer/CenterContainer/ViewportContainer
onready var database = $HBoxContainer/VBoxContainer/Database

func _on_ViewportContainer_chessboard_clicked(pos, action):
	var color = ctrlPanel.get_selected_piece_color()
	var piece = ctrlPanel.get_selected_piece()
	if action:
		board.add_piece(pos, piece, color)
	else:
		board.clear_piece(pos)

func _on_MenuBar_FEN_Pasted(fen):
	board.setup_from_FEN(fen)
	ctrlPanel.setup_from_FEN(fen)


func _on_Chessboard_piece_moved(move):
	print("Piece moved: ", move)
	ctrlPanel.add_move(move)


func _on_ModeControlPanel_clear_all():
	board.clear_all_pieces()


func _on_ModeControlPanel_init_position():
	board.setup_from_FEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")


func _on_ModeControlPanel_mode_changed(new_mode, old_mode):
	mode = new_mode
	switch_mode(old_mode)

func switch_mode(old):
	match old:
		Gb.MODE_SETUP:
			vpCtrl.set_mouse_filter(MOUSE_FILTER_IGNORE)
			database.add_entry_fen(game.to_fen())
	match mode:
		Gb.MODE_SETUP:
			vpCtrl.set_mouse_filter(MOUSE_FILTER_STOP)
		Gb.MODE_DATABASE:
			ctrlPanel.set_database_list(database.get_content())


func _on_ModeControlPanel_move_played(uci):
	board.play_uci(uci)
