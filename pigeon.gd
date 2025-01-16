extends HTTPRequest

@export var current_version:String = ""

const PCK_URL:String = "https://api.github.com/repos/Sparrowworks/Pigeon/releases/latest"

func _ready() -> void:
	var err:Error = request(PCK_URL)
	if err != OK:
		print("Failed to send request.")

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != 0:
		print("Operation failed with result: " + str(result))
		return
	
	if response_code != 200:
		print("Request failed with response code: " + str(response_code))
		return
	
	var latest_version:Dictionary = JSON.parse_string(body.get_string_from_utf8())
	if current_version != latest_version["name"]:
		print("Update Available! Installing...")
	else:
		print("You are using the latest version.")
