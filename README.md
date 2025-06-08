*Note, this is a fork aiming to make the project installable again without modification, I am not knowledgable in  the tools, but the main repo hasn't been touched in a while and I think it's a handy project.

*I am not sure if the signup page ever worked, if it just doesn't work on my computer, if I'm being stupid, or what's up with that, but it's not a priority for me as it can be done in the server console.

*Todo 
- learn git and reference 'https://github.com/Crypto137/MHServerEmuWebAssets' in the web dir to keep it up do date (Not sure if this is the best way, but I'll figgure it out as i go along x)
- ~~Look into LiveTuning and symlinking instead of copying files to modify livetuning without a rebuild~~ I've deemed this to be to much of a hassle unless livetuning gets split into it's own subdir
- probably something more, but I can't remember right now :D

# MHO Helicarrier

This project aims to containerize the MHServerEmu server so it can be run on any computer easily

## Getting Started

### Podman

**NOTE: The Steam Deck has podman installed by default as of Steam OS 3.5 so this step can be skipped** 

Download [podman](https://podman.io) on to your computer. These instructions should work on Mac, Linux, and Windows without much modification. Once podman is
fully set up (make sure to read through installation instructions thoroughly), the next steps can be followed.

### Finding the Necessary Files

In order to build the image, both the `mu_cdata.sip` and `Calligraphy.sip` files will need to be copied into the `data/` folder of this project. These files can be found in
the `Data/Game/` folder of your Marvel Heroes installation. These instructions will not provide any instructions on how to download the client. After copying the files into the `data/`
folder, move on to the next step.

### Set up the Container Image

Open your preferred terminal (e.g. PowerShell, iTerm2, Konsole) and navigate to the folder of this project (using `cd`). Once in the correct folder, run the following command:

```bash
./BuildImage.sh
```

This will handle pulling the latest Alpine Linux image, downloading and building the MHServerEmu code, setting up the necessary server proxy, and uploading the needed
configuration files the server will require. Once the image has been successfully been built, the server can now be run!

### Running the Server

#### Steam Deck-specific Instructions

Since podman runs without root on the Steam Deck, the following command must be run once before starting the server for the first time:

```bash
sudo sysctl net.ipv4.ip_unprivileged_port_start=80
```

**NOTE: This setting may reset from time to time so it is best to run this step every time the server is run. Open `RunServer.sh` and uncomment the line that runs this command every
time the server is run, if desired. Your password will need to be entered every time you start the server.**

This will allow podman to bind to the necessary ports on your computer to be able to run the server.

#### Starting the Server

Now that the image has been built, the server is ready to go! Run the following command in your terminal to run the server:

```bash
./RunServer.sh
```

This will start up the podman image and start the MHServerEmu server. At this point, the client can be run and used to connect to our server.

### Shutting Down the Server

To shut down the server, hit CTRL-C in the terminal. This will end the server sessions and gracefully shut down the rest of the image.

### Connecting a Client

#### Steam Deck-specific Instructions

##### Patching the client
As of Wine version 10.6 and Proton Experimental 2025-06-05, this is no longer needed

<strike>The client needs to be patched before it can connect to our server. 

* @TobiX made an online patcher for ease of use https://tobix.github.io/mh-linux-patch/ 

Or you can do it by download GHex from the Discovery store in Desktop Mode on the Steam Deck. Find
MarvelHeroesOmega.exe in your Marvel Heroes installation (`UnrealEngine3/Binaries/Win64`), make a backup copy, and open the original with GHex. In the
menu for GHex, select "Jump to Byte" (or CTRL-J) and enter `0x19B317E` and change `75` to `EB`. Select "Save As" and overwrite MarvelHeroesOmega.exe.</strike>

#### General Instructions

Run the Marvel Heroes client with the following command line parameters:

```bash
-robocopy -nosteam -siteconfigurl=localhost/SiteConfig.xml -emailaddress=test@test.com -password=123
```

This project defaults to bypassing the authentication process so users do not need to create an account before starting the game. All of the player's
data will be stored in the `player_data/` folder.

## Set up Steam Shortcuts for Steam Deck

### Adding Marvel Heroes Omega

**NOTE: These instructions are only if you do not have the Steam version of Marvel Heroes Omega**

Open Dolphin (file explorer) and navigate to your Marvel Heroes installation folder. Go to the folder `Unreal Engine3/Binaries/Win64` and right-click on MarvelHeroesOmega.exe and press "Add to Steam".
You should now see a shortcut to launch Marvel Heroes Omega in your Library. 

### Shortcut Settings for Client

Press the settings cog for MarvelHeroesOmega.exe in your Library to open the settings and change the following settings:

**Shortcut:**</br>
* **Name:** Marvel Heroes Omega</br>
* **Launch Options:** `-robocopy -nosteam -siteconfigurl=localhost/SiteConfig.xml -emailaddress=test1@test.com -password=123`

**Compatibility:**</br>
* **Force the use of a specific Steam Play compatibility tool:** Checked
* **Proton version:** Proton GE 8-24 or Proton Experimental (really most versions should work okay)

### Adding MHServerEmu Launch

Open Dolphin (file explorer) and navigate to this project's folder. Right-click on "RunServer.sh" and press "Add to Steam". You should now see a shortcut for "RunServer.sh" in your Steam Library.

### Shortcut Settings for Server

Press the settings cog for RunServer.sh in your Library to open the settings and change the following settings:

**Shortcut:**</br>
* **Name:** MHO Server</br>
* **Launch Options:** `--workdir [path to MHOHelicarrier folder] -e [path to MHOHelicarrier folder]/RunServer.sh`

### Launching the Server and Client

Switch back to Game Mode, launch the MHO Server shortcut and wait for the server to completely start up. Hit the "STEAM" button, go back to Home (while leaving MHO Server running) and launch Marvel Heroes 
Omega. If everything is set up correctly, the game should launch into Avengers Tower while skipping the login screen. Enjoy the game!

### Shutting Down the Game

When you're done playing, quit out of Marvel Heroes Omega and switch to MHO Server. Either set up a controller shortcut for the B button to hit CTRL-C or hit the STEAM button and press "Exit Game" on MHO Server.

### Modifying Config Files

By default `data/config.ini/Config.IgnoreSessionToken.JSON.ini` is used, you can change between some presets in `Dockerfile` or edit the files in data/config.ini/ directly.
I've made them to be config overrides so you just add the sections you want from https://github.com/Crypto137/MHServerEmu/blob/master/src/MHServerEmu/Config.ini, which has the complete list of config.ini options. (You need to also add the [] section above if you're adding from a section that isn't already in the file)

For some extra seasonal loot you can enable them in data/PatchDataSpecialEvents.json, I will try to keep it up to date, if not the source version can be found https://github.com/Crypto137/MHServerEmu/blob/master/src/MHServerEmu.Games/Data/Game/Patches/PatchDataSpecialEvents.json, you can just copy from there if something new gets added I've not updated yet. (It seems like nothing breaks if you enable them all, but I can't guarrantee that)

***Note, you need to rebuild the image for config changes to get applied**
