extends HBoxContainer

func set_line(count, wmove, bmove):
	set_count(count)
	set_white_move(wmove)
	set_black_move(bmove)

func set_count(count):
	$PanelContainer/MoveCount.set_text(str(count))

func set_white_move(move):
	$PanelContainer2/WhiteMove.set_text(move)

func set_black_move(move):
	$PanelContainer3/BlackMove.set_text(move)
