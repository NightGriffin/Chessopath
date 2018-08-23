extends MarginContainer

signal best_move_updated(uci)
signal move_selected(uci)

onready var table = $VBoxContainer/ItemList

var WdlTex = {
		tbClient.WDL_UNKNOWN : preload("res://Images/WdlIcons6.png"),
		tbClient.WDL_LOSS : preload("res://Images/WdlIcons1.png"),
		tbClient.WDL_BLESSED_LOSS : preload("res://Images/WdlIcons4.png"),
		tbClient.WDL_DRAW : preload("res://Images/WdlIcons3.png"),
		tbClient.WDL_CURSED_WIN : preload("res://Images/WdlIcons5.png"),
		tbClient.WDL_WIN : preload("res://Images/WdlIcons2.png")
	 }

func get_tablebase_from_fen(fen):
	var error = tbClient.request_tablebase_from_fen(fen)
	var res = yield(tbClient, "tablebase_results")
	if res[0] in range(200, 300):
		fill_table_from_json(res[1])
	else:
		table.clear()


func fill_table_from_json(json):
	table.clear()
	for m in json["moves"]:
		var wdl = tbClient.WDL_UNKNOWN
		if m["wdl"] != null:
			wdl = -int(m["wdl"])
		var tex = WdlTex[wdl]
		table.add_item(m["san"], tex)
	emit_signal("best_move_updated", json["moves"][0]["uci"])


func _on_ItemList_item_activated(index):
	print("Index activated = ", index, ", uci = ", tbClient.lastTableData["moves"][index]["uci"])
	emit_signal("move_selected", tbClient.lastTableData["moves"][index]["uci"])