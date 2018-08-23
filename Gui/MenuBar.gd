extends PanelContainer

signal FEN_Pasted(fen)

enum MenuItems {
		HELP_ABOUT,
		FILE_NEW_DB = 10, FILE_OPEN, FILE_CLOSE_DB, FILE_EXIT,
		EDIT_COPY = 30, EDIT_PASTE,
		GAME_NEW = 50, GAME_PASTE_FEN, GAME_COPY_FEN,
		VIEW_WHAT = 70,
		OPTION_WHAT = 90
}

var AboutDialog = load("res://Gui/About.tscn").instance()
var InputDialog = load("res://Gui/StringInputDialog.tscn").instance()

func _ready():
	add_child(InputDialog)
	add_child(AboutDialog)
	InputDialog.set_process_unhandled_input(false)

	setup_help_menu($HBoxContainer/Help.get_popup())
	setup_file_menu($HBoxContainer/File.get_popup())
	setup_edit_menu($HBoxContainer/Edit.get_popup())
	setup_game_menu($HBoxContainer/Game.get_popup())
	setup_view_menu($HBoxContainer/View.get_popup())
	setup_option_menu($HBoxContainer/Options.get_popup())

func setup_help_menu(menu):
	menu.add_item("About", HELP_ABOUT)
	menu.connect("id_pressed", self, "id_pressed")

func setup_file_menu(menu):
	menu.add_item("New DB", FILE_NEW_DB)
	menu.add_item("Open", FILE_OPEN)
	menu.add_item("Close DB", FILE_CLOSE_DB)
	menu.add_item("Exit", FILE_EXIT)
	menu.connect("id_pressed", self, "id_pressed")

func setup_edit_menu(menu):
	menu.add_item("Copy", EDIT_COPY)
	menu.add_item("Paste", EDIT_PASTE)
	menu.connect("id_pressed", self, "id_pressed")

func setup_game_menu(menu):
	menu.add_item("New Game", GAME_NEW)
	menu.add_item("Copy FEN", GAME_COPY_FEN)
	menu.add_item("Paste FEN", GAME_PASTE_FEN)
	menu.connect("id_pressed", self, "id_pressed")

func setup_view_menu(menu):
	menu.add_item("???", VIEW_WHAT)
	menu.connect("id_pressed", self, "id_pressed")

func setup_option_menu(menu):
	menu.add_check_item("???", OPTION_WHAT)
	menu.connect("id_pressed", self, "id_pressed")

func id_pressed(id):
	match id:
		HELP_ABOUT:
			AboutDialog.popup_centered()
			yield(AboutDialog, "confirmed")
			AboutDialog.hide()
		GAME_PASTE_FEN:
			InputDialog.set_title("Paste FEN")
			InputDialog.set_label("FEN")
			InputDialog.popup_centered()
			yield(InputDialog, "confirmed")
			emit_signal("FEN_Pasted", InputDialog.get_input())
		GAME_COPY_FEN:
			OS.set_clipboard(game.to_fen())
		FILE_EXIT:
			get_tree().quit()
