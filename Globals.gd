extends Node

enum PieceColors {
		COLOR_BLACK,
		COLOR_WHITE
	}

enum PieceNames {
		PIECE_QUEEN,
		PIECE_KING,
		PIECE_ROOK,
		PIECE_KNIGHT,
		PIECE_BISHOP,
		PIECE_PAWN
	}

enum AppMode {
		MODE_SETUP,
		MODE_TRAINING,
		MODE_ANALYZE,
		MODE_DATABASE
	}

enum MoveType {
		MOVE_VALID,
		MOVE_CAPTURE
	}

enum Castlings {
		CASTLE_WQ,
		CASTLE_WK,
		CASTLE_BQ,
		CASTLE_BK
	}

static func square_to_algebric(square):
	var val = ""
	match int(square.x):
		0:
			val = "a"
		1:
			val = "b"
		2:
			val = "c"
		3:
			val = "d"
		4:
			val = "e"
		5:
			val = "f"
		6:
			val = "g"
		_:
			val = "h"
	return val + str(8 - square.y)


static func move_to_algebric(piece, src, dst):
	return piece.get_piece_initial() + square_to_algebric(dst)


static func algebric_to_square(val):
	var base = "a".ord_at(0)
	var x = val.ord_at(0) - base
	var y = 8 - int(val[1])
	return Vector2(x, y)
		

static func get_color_from_name(name):
	match name.to_upper():
		"W":
			return COLOR_WHITE
		_:
			return COLOR_BLACK


static func get_piece_from_name(name):
	match name.to_upper():
		"Q":
			return PIECE_QUEEN
		"K":
			return PIECE_KING
		"B":
			return PIECE_BISHOP
		"N":
			return PIECE_KNIGHT
		"R":
			return PIECE_ROOK
		_:
			return PIECE_PAWN


static func is_promotion(piece, square):
	return  piece.get_piece() == PIECE_PAWN && (
			piece.get_color() == COLOR_BLACK && square.y == 7 ||
			piece.get_color() == COLOR_WHITE && square.y == 0)

