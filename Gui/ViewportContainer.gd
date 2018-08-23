extends ViewportContainer

signal chessboard_clicked(pos, action)

onready var board = $Viewport/Chessboard

func _ready():
	$Viewport.size = board.get_size()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("ui_accept"):
			emit_signal("chessboard_clicked", event.position, true)
		elif event.is_action_pressed("ui_cancel"):
			emit_signal("chessboard_clicked", event.position, false)
