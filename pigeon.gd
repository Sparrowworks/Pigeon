extends HTTPRequest

@export var current_version:String = ""

const PCK_URL:String = "https://api.github.com/repos/Sparrowworks/Pigeon/releases/latest"
const TEMP_PCK_PATH:String = "user://update.pck"

var pck_path:String
func _init() -> void:
	pck_path += OS.get_executable_path().get_base_dir() + "/" + ProjectSettings.get_setting("application/config/name") + ".pck"
	print(pck_path)

func _ready() -> void:
	var err:Error = request(PCK_URL)
	if err != OK:
		print("Failed to send request.")

var is_fetching:bool = true
var download_url:String
func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == 0 and response_code == 200:
		if is_fetching:
			print("Fetching complete")

			var latest_version:Dictionary = JSON.parse_string(body.get_string_from_utf8())
			if current_version != latest_version["name"]:
				print("Update Available! Downloading...")

				download_url = latest_version["assets"][0]["browser_download_url"]
				print(download_url)

				request(download_url)
				is_fetching = false
			else:
				print("You are using the latest version.")
		else:
			print("Download complete, Installing...")
			print(body.get_string_from_utf8())
	else:
		print("Download failed with result: " + str(result) + " and response code: " + str(response_code))
