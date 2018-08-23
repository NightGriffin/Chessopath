extends Node2D

signal piece_moved(move)
signal promote_pawn(piece)

class DragInfo:
	var piece
	var square

onready var tiles = $TileMap
onready var highlights = $Highlights
onready var tween = $Tween

var pieceDragged = null

const PIECE = preload("res://Game/Chesspiece.tscn")
const Gb = preload("res://Globals.gd")

func create_drag_info(p, s):
	var info = DragInfo.new()
	info.piece = p
	info.square = s
	return info


func create_piece(square):
	var p = PIECE.instance()
	p.set_position(tiles.map_to_world(square))
	add_child(p)
	game.pieces[square] = p
	p.connect("grabbed", self, "piece_grabbed", [p])
	return p


func get_size():
	var size = Vector2(0.0, 0.0)
	if tiles != null:
		size = tiles.get_used_rect().size * tiles.get_cell_size()
	return size


func add_piece(pos, p, c):
	var square = tiles.world_to_map(pos)
	if tiles.get_cellv(square) != tiles.INVALID_CELL:
		var node
		if  game.pieces.has(square):
			node = game.pieces[square]
		else:
			node = create_piece(square)
		node.set_piece(p)
		node.set_color(c)


func clear_all_pieces():
	for v in game.pieces.values():
		remove_child(v)
		v.queue_free()
	game.pieces.clear()


func clear_piece(pos):
	var square = tiles.world_to_map(pos)
	if tiles.get_cellv(square) != tiles.INVALID_CELL && game.pieces.has(square):
		var node = game.pieces[square]
		game.pieces.erase(square)
		remove_child(node)
		node.queue_free()


func setup_from_FEN(fen):
	clear_all_pieces()
	var parts = fen.split(" ")
	if parts.size() != 6:
		print("Invalid FEN")
		return
	setup_ranks(parts[0])


func setup_ranks(value):
	var ranks = value.split("/")
	if ranks.size() != 8:
		return
	for row in range(8):
		var s = ranks[row]
		var col = 0
		for i in range(8):
			var p = s[i]
			if (p.is_valid_integer()):
				col += p.to_int()
			else:
				var node
				var square = Vector2(col, row)
				if game.pieces.has(square):
					node = game.pieces[square]
				else:
					node = create_piece(square)
				node.set_from_fen(p)
				col += 1
			if col >= 8:
				break;


func piece_grabbed(pos, piece):
	var square = tiles.world_to_map(pos)
	pieceDragged = create_drag_info(piece, square)
	game.pieces.erase(square)
	piece.set_centered(true)
	piece.set_position(get_viewport().get_mouse_position())
	for info in game.get_valid_square(piece, square):
		highlights.set_cellv(info.square, info.type)


func _input(event):
	if pieceDragged != null:
		if event is InputEventMouseMotion:
			pieceDragged.piece.position = event.position
		elif event.is_action_released("ui_accept"):
			drop_piece(event.position)


func drop_piece(pos):
	highlights.clear()
	var square = tiles.world_to_map(pos)
	var piece = pieceDragged.piece
	var src = pieceDragged.square
	piece.set_centered(false)
	piece.set_position(tiles.map_to_world(square))
	if game.pieces.has(square):
		var old = game.pieces[square]
		remove_child(old)
		game.pieces.erase(square)
		old.queue_free()
	game.pieces[square] = piece
	pieceDragged = null
	game.sideToMove = (game.sideToMove + 1) % 2
	emit_signal("piece_moved", Gb.move_to_algebric(piece, src, square))


func play_uci(move):
	var src = Gb.algebric_to_square(move.substr(0, 2))
	var dst = Gb.algebric_to_square(move.substr(2, 2))
	var promo = ""
	if move.length() == 5:
		promo = move[4]
	var piece = game.pieces[src]
	game.pieces.erase(src)
	tween.interpolate_property(piece, "position", piece.position, tiles.map_to_world(dst), 0.5, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	game.pieces[dst] = piece
	game.sideToMove = (game.sideToMove + 1) % 2
	if promo:
		piece.set_piece(Gb.get_piece_from_name(promo))
	emit_signal("piece_moved", Gb.move_to_algebric(piece, src, dst))

