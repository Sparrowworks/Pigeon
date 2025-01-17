extends HTTPRequest

@export var current_version:String = ""

const PCK_URL:String = "https://api.github.com/repos/Sparrowworks/Pigeon/releases/latest"
const NEW_PCK_BACKUP_PATH:String = "user://update.pck"
const OLD_PCK_BACKUP_PATH:String = "user://old.pck"

var pck_path:String
func _init() -> void:
	pck_path = OS.get_executable_path().get_base_dir() + "/" + ProjectSettings.get_setting("application/config/name") + ".pck"
	print(pck_path)

func _ready() -> void:
	var err:Error = request(PCK_URL) # Fetch URL
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

			var update_backup:FileAccess = FileAccess.open(NEW_PCK_BACKUP_PATH, FileAccess.WRITE)
			update_backup.store_buffer(body)
			update_backup.close()
			print("New PCK backed up in: ", NEW_PCK_BACKUP_PATH)

			if (FileAccess.file_exists(pck_path)):
				var old_pck_backup:FileAccess = FileAccess.open(OLD_PCK_BACKUP_PATH, FileAccess.WRITE)
				var file_to_clone:FileAccess = FileAccess.open(pck_path, FileAccess.READ)
				old_pck_backup.store_buffer(file_to_clone.get_buffer(file_to_clone.get_length()))
				file_to_clone.close()
				old_pck_backup.close()

			var current_pck:FileAccess = FileAccess.open(pck_path, FileAccess.WRITE)
			DirAccess.remove_absolute(pck_path)
			current_pck.store_buffer(body)
			current_pck.close()
			print("PCK Changed")
	else:
		print("Download failed with result: " + str(result) + " and response code: " + str(response_code))
