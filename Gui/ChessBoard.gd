extends GridContainer

export(float) var aspect_ratio = 1.0

func _ready():
	var rect = get_size()
	var x = min(rect.x, rect.y / aspect_ratio)
	var y = min(rect.y, rect.x * aspect_ratio)
	set_size(Vector2(x, y))

func get_board_rect():
	var rect = get_rect()
	rect.size.x = min(rect.size.x, rect.size.y / aspect_ratio)
	rect.size.y = min(rect.size.y, rect.size.x * aspect_ratio)
	return rect

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_ready()
		print(what)