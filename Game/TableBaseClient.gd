extends Node

signal tablebase_results(resp, json)
signal best_move_result(uci)

enum WDL {
		WDL_UNKNOWN = -3,
		WDL_LOSS,
		WDL_BLESSED_LOSS,
		WDL_DRAW,
		WDL_CURSED_WIN,
		WDL_WIN
	}

enum ResponseCode {
		RC_UNKNOWN,
		RC_OK = 200,
		RC_BAD_REQUEST = 400,
		RC_NOT_FOUND = 404
	}

var client
var lastTableData = null
var lastResponseCode = RC_UNKNOWN

const SITE = "http://tablebase.lichess.ovh/standard?fen="

func _ready():
	client = HTTPRequest.new()
	add_child(client)
	client.connect("request_completed", self, "_on_HTTPRequest_request_completed")

func request_tablebase_from_fen(fen):
	var url = SITE + fen.replace(" ", "_")
	return client.request(url)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	lastResponseCode = response_code
	match response_code:
		RC_OK:
			print("Successful request")
			lastTableData = parse_json(body.get_string_from_utf8())
		RC_BAD_REQUEST:
			printerr("Bad request")
			lastTableData = null
		RC_NOT_FOUND:
			printerr("Tablebase not found")
			lastTableData = null
		_:
			printerr("Response = ", response_code)
			lastTableData = null
	emit_signal("tablebase_results", response_code, lastTableData)

func request_best_move_from_fen(fen):
	request_tablebase_from_fen(fen)
	var uci = ""
	var res = yield(self, "tablebase_results")
	if res[0] in range(200, 300):
		uci = res[1]["moves"][0]["uci"]
	emit_signal("best_move_result", uci)