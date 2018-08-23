extends MarginContainer

signal content_changed()

onready var dbName = $HBoxContainer/Name

var current
var dbContent = []

const EG_EXTENSION = ".efl"
const DEFAULT_DIR = "user://EndGame/"
const DEFAULT_FILE = DEFAULT_DIR + "default" + EG_EXTENSION

func _ready():
	open_database(DEFAULT_FILE)


func open_database(path):
	dbName.set_text(path)
	load_current_database()
	emit_signal("content_changed")


func close_current_database():
	save_current_database()
	dbName.set_text("")
	emit_signal("content_changed")


func create_database(path):
	if dbName.get_text():
		close_current_database()
	dbContent.clear()
	dbName.set_text(path)
	emit_signal("content_changed")


func save_current_database():
	var save = File.new()
	save.open(dbName.get_text(), File.WRITE)
	for fen in dbContent:
		save.store_line(to_json(fen))
	save.close()


func load_current_database():
	var save = File.new()
	if not save.file_exists(dbName.get_text()):
	    return
	save.open(dbName, File.READ)
	dbContent.clear()
	while not save.eof_reached():
		var line = parse_json(save.get_line())
		dbContent.push_back(line)
	save.close()


func add_entry_fen(fen):
	dbContent.push_back(fen)
	save_current_database()
	emit_signal("content_changed")


func get_content():
	return dbContent
