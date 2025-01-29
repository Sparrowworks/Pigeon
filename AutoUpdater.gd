class_name AutoUpdater extends Control

@export var pck_url: String = "https://api.github.com/repos/Sparrowworks/Pigeon/releases/latest"

@onready var current_version: String = ProjectSettings.get_setting("application/config/version")
@onready var pigeon: HTTPRequest = $Pigeon
@onready var version_text: Label = %VersionText
@onready var found_text: Label = %Found

var path_to_pck: String
var download_url: String
var download_file: String

func _ready() -> void:
	path_to_pck = OS.get_executable_path().get_base_dir() + "/" + ProjectSettings.get_setting("application/config/name") + ".pck"
	version_text.text = current_version

func _process(_delta: float) -> void:
	if pigeon.get_body_size() > 0:
		var downloaded: float = float(pigeon.get_downloaded_bytes()) / 1024
		var total: float = float(pigeon.get_body_size()) / 1024
		found_text.text = "Downloaded: " + str(downloaded) + "KB /" + str(total) + "KB"

var has_fetched: bool = false
func _on_pigeon_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == 0 and response_code == 200:
		set_process(false)

		if has_fetched == false:
			var latest_version: Dictionary = JSON.parse_string(body.get_string_from_utf8())

			if current_version != latest_version["name"]:
				found_text.text = "Found new version: " + latest_version["name"]

				download_url = latest_version["assets"][0]["browser_download_url"]
				download_file = "user://" + latest_version["assets"][0]["name"]

				print(download_url)
				has_fetched = true

			else:
				found_text.text = "Already has the newest version."

		else:
			found_text.text = "Download complete"
			update_pck()

	else:
		found_text.text = "Fetch/Download error: " + str(result) + "; " + str(response_code)

func _on_check_button_pressed() -> void:
	var error: Error = pigeon.request(pck_url)

	if error != OK:
		found_text.text = "Fetch error: " + str(error)

func _on_download_button_pressed() -> void:
	pigeon.download_file = download_file
	var error: Error = pigeon.request(download_url)

	if error != OK:
		found_text.text = "Download error: " + str(error)

func update_pck() -> void:
	DirAccess.copy_absolute(download_file,path_to_pck)
	DirAccess.remove_absolute(download_file)

	found_text.text = "Game was updated. Click the button to restart it."

	$Panel/VBoxContainer/Control.hide()
	$Panel/VBoxContainer/Control2.hide()
	$Panel/VBoxContainer/Control3.show()

func _on_restart_button_pressed() -> void:
	OS.set_restart_on_exit(true)
	get_tree().quit()
