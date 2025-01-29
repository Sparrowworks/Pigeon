class_name AutoUpdater extends Control

@export var current_version: String = "v" + ProjectSettings.get_setting("application/config/version")
@export var pck_url: String = "https://api.github.com/repos/Sparrowworks/Pigeon/releases/latest"

@onready var fetch_request: HTTPRequest = $FetchRequest
@onready var download_request: HTTPRequest = $DownloadRequest

@onready var version_text: Label = %VersionText
@onready var found_text: Label = %Found

var path_to_pck: String
var download_url: String
var download_file: String

func _ready() -> void:
	path_to_pck = OS.get_executable_path().get_base_dir() + "/" + ProjectSettings.get_setting("application/config/name") + ".pck"
	version_text.text = current_version

func _process(delta: float) -> void:
	if download_request.get_body_size() > 0:
		var downloaded: float = float(download_request.get_downloaded_bytes()) / 1024
		var total: float = float(download_request.get_body_size()) / 1024
		found_text.text = "Downloaded: " + str(downloaded) + "KB /" + str(total) + "KB"

func _on_fetch_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == 0 and response_code == 200:
		var latest_version: Dictionary = JSON.parse_string(body.get_string_from_utf8())

		if current_version != latest_version["name"]:
			found_text.text = "Found new version: " + latest_version["name"]

			download_url = latest_version["assets"][0]["browser_download_url"]
			download_file = "user://" + latest_version["assets"][0]["name"]
		else:
			found_text.text = "Already has the newest version."
	else:
		found_text.text = "Fetch error: " + str(result) + "; " + str(response_code)

func _on_download_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == 0 and response_code == 200:
		set_process(false)
		found_text.text = "Download complete"

		update_pck()

func _on_check_button_pressed() -> void:
	var error: Error = fetch_request.request(pck_url)

	if error != OK:
		found_text.text = "Fetch error: " + str(error)

func _on_download_button_pressed() -> void:
	download_request.download_file = download_file
	var error: Error = download_request.request(download_url)

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
