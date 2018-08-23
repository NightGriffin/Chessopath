extends AcceptDialog

func set_label(value):
	$Layout/Label.set_text(value)

func get_input():
	return $Layout/LineEdit.get_text()

func _on_StringInputDialog_about_to_show():
	$Layout/LineEdit.set_text("")
	set_process_unhandled_input(true)

func _on_StringInputDialog_popup_hide():
	set_process_unhandled_input(false)

func _unhandled_input(event):
	if event.is_action_pressed("ui_paste"):
		$Layout/LineEdit.set_text(OS.get_clipboard())
