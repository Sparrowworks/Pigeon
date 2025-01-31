# Pigeon

## An auto-updater for Godot games, works by downloading and replacing .pck files

### Features
- User Notifications: Alerts users when a new version is available.
- Version Checking: Compares installed version with the latest available version.
- Download Latest Version: Automatically downloads and installs the latest updates.
- Cross-Platform Support: Works on various platforms supported by Godot.
- Diverse Update Sources: For a comprehensive list, read below.

### Installation
- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) or download the repository.
- Add AutoUpdater to your Godot project however you wish.

### Setup
1. Github Releases (for public repositories):  

**You must [upload](https://docs.github.com/en/get-started/start-your-journey/uploading-a-project-to-github) your project on Github**  

- Go to AutoUpdate node or AutoUpdate.gd and change "Sparrowworks/Pigeon" to *YourGithubNameOrOrganisation/YourGame'sName*.

![image](https://github.com/user-attachments/assets/dbbefbde-fbbf-4b30-8316-d94c299abe67)

![image](https://github.com/user-attachments/assets/593322f5-76e8-4308-8e03-ec5033412051)

**and that's it!** now whenever you make an update, simply:

- Go to Project Settings.

![image](https://github.com/user-attachments/assets/0c2e8e29-033a-45da-a812-ac79a4ec72a3)

- Change the version.

![image](https://github.com/user-attachments/assets/72a1c3a5-563b-472e-9764-5e6f4ab3a778)

- [Export PCK](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html)

- Make a [release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) using the new pck and new version name.
