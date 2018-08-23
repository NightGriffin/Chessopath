extends Node

const Gb = preload("res://Globals.gd")

var sideToMove = Gb.COLOR_WHITE
var epTarget = null
var moveList = []
var firstMove = 1
var pieces = {}
var halfMoveClock = 0
var castlings = ""

class MoveInfo:
	var type
	var square

func MoveInfo(t, s):
	var info = MoveInfo.new()
	info.type = t
	info.square = s
	return info


func set_move_list(first, list):
	firstMove = first
	moveList = list


func get_move_list():
	return moveList


func get_first_move():
	return firstMove


func get_valid_square(piece, square):
	var results = []
	match piece.get_piece():
		_:
			results = get_pawn_move_squares(piece, square)
	return results


func get_pawn_move_squares(piece, square):
	var results = []
	var isStarting
	var moveInc
	if piece.get_color() ==  Gb.COLOR_BLACK:
		moveInc = Vector2(0, 1)
		isStarting = square.y == 1
	else:
		moveInc = Vector2(0, -1)
		isStarting = square.y == 6
	var targetMove = square + moveInc
	if !pieces.has(targetMove):
		results.push_back(MoveInfo(Gb.MOVE_VALID, targetMove))
		if isStarting and !pieces.has(targetMove + moveInc):
			results.push_back(MoveInfo(Gb.MOVE_VALID, targetMove + moveInc))
	var captureSquare = square + Vector2(-1, 0) + moveInc
	if pieces.has(captureSquare) or captureSquare == epTarget:
		results.push_back(MoveInfo(Gb.MOVE_CAPTURE, captureSquare))
	captureSquare = square + Vector2(1, 0) + moveInc
	if pieces.has(captureSquare) or captureSquare == epTarget:
		results.push_back(MoveInfo(Gb.MOVE_CAPTURE, captureSquare))
	return results


func to_fen():
	var fen = ranks_to_fen()
	fen += " "
	fen += side_to_move_to_str()
	fen += " "
	fen += castlings_to_fen()
	fen += " "
	fen += en_passant_to_str()
	fen += " " + str(halfMoveClock) + " "
	fen += str(get_full_move_counter())
	return fen


func ranks_to_fen():
	var fen = ""
	for r in range(8):
		var empty = 0
		for c in range(8):
			var square = Vector2(c, r)
			if pieces.has(square):
				var p = pieces[square]
				if empty > 0:
					fen += str(empty)
					empty = 0
				var val = p.get_piece_initial(false)
				if p.get_color() == Gb.COLOR_BLACK:
					val = val.to_lower()
				fen += val
			else:
				empty += 1
			if c >= 7 && empty > 0:
				fen += str(empty)
		if r < 7:
			fen += "/"
	return fen


func side_to_move_to_str():
	if sideToMove == Gb.COLOR_BLACK:
		return "b"
	return "w"


func castlings_to_fen():
	if not castlings:
		return "-"
	return castlings


func en_passant_to_str():
	if not epTarget:
		return "-"
	return Gb.square_to_algebric(epTarget)


func get_full_move_counter():
	var fullMoveCount = moveList.size() / 2
	var evenMove = fullMoveCount % 2 == 0
	if !evenMove and sideToMove == Gb.COLOR_WHITE:
		fullMoveCount += 1
	return firstMove + fullMoveCount

