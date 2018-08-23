tool
extends Sprite

const Gb = preload("res://Globals.gd")

signal grabbed(pos)

export(int, "Queen", "King", "Rook", "Knight", "Bishop", "Pawn") var piece = 0 setget set_piece, get_piece
export(int, "White", "Black") var color = 0 setget set_color, get_color

const IMAGE_SIZE = 60

func _ready():
	pass

func set_piece(target):
	if piece != target:
		piece = target
		set_image()

func get_piece():
	return piece

func set_color(target):
	if target != color:
		color = target
		set_image()

func get_color():
	return color

func set_image():
	var pos = Vector2(piece * IMAGE_SIZE, color * IMAGE_SIZE)
	region_rect.position = pos

func set_from_fen(value):
	var upper = value.to_upper()
	if value == upper:
		set_color(Gb.COLOR_WHITE)
	else:
		set_color(Gb.COLOR_BLACK) 
	set_piece(Gb.get_piece_from_name(upper))

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_accept"):
		emit_signal("grabbed", event.position)

func get_piece_initial(ignore_pawn = true):
	match piece:
		Gb.PIECE_QUEEN:
			return "Q"
		Gb.PIECE_KING:
			return "K"
		Gb.PIECE_ROOK:
			return "R"
		Gb.PIECE_BISHOP:
			return "B"
		Gb.PIECE_KNIGHT:
			return "N"
		_:
			if ignore_pawn:
				return ""
			return "P"
