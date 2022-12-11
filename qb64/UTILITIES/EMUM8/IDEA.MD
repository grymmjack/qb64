# EMUM8
> Front end for emulators

## Goals
- Convention vs. configuration
    - File-system introspection
    - Configuration in files
    - Scaffolded and logical directory structure
- Easy to backup, maintain, add, and cultivate
- Transparent and self-documenting configuration
- CLI and GUI version front-ends

## Features
- Multiple systems
- Global tags
- Per-system organization, categories, tags 
- Configuration in files

## CLI
`emum8 {system|directive} [verb] [command] [args]`

### System | Directives
- `gui`
     - `version`
     - `path`
- `config`
    - `list`
    - `show`
    - `set`
- `backup`
    - `all`
    - `{system}`
- `info`
- `rom` 
- `emu`
    - `list`
    - `uninstall`
    - `install`
- `version`
- `update`
    - `emu`
- `stats`
    - `system`
        - `rom`
- `urls`
    - `add`
    - `remove`
    - `list`
        - `emum8`
        - `system`

### Verbs
- `play`
- `load`

#### CLI Examples
- `emum8 atari/2600 play warlords`
- `emum8 atari/2600 load warlords [savefile]`
- `emum8 gui atari/2600/warlords` : load gui to rom
- `emum8 gui atari/2600` : load gui to system
- `emum8 gui atari` : load gui to mfg


## File System
```
/EMUM8
    /git.ini
        [CONFIG]
        username=grymmjack
        repo=EMUM8-private
    /ATARI
        /2600
            /logo.t.png
            /logo.png
            /system.t.png
            /system.png
            /sys.ini
                [DATA]
                mfg=Atari
                name=2600
                year=1978
                url=https://whatever.org
            /urls.ini
                [LINK NAME]
                url=https://whatever.org
                ...
            /emu.ini
                [DATA]
                name=Stella
                url=https://whatever.org
                exts=bin,bip,bop
                [CLI]
                path={whatever}
                exec={path} {rom}
                load={path} {rom} /load {whatever}
                [DIRS]
                saves={whatever}
                states={whatever}
                screenshots={whatever}
                video_captures={whatever}
                audio_captures={whatever}
                [CAN]
                debug=1
                print=1
                save=1
                multiplayer=1
                [INPUTS]
                joystick=1
                gamepad=1
                keyboard=1
                mouse=1
                midi=1
                [CAPTURES]
                audio=1
                video=1
                midi=1
            /ROMS
                /warlords.bin
                /...
            /DATA
                /WARLORDS/
                    /warlords.t.png
                    /warlords.f.png
                    /rom.ini
                        [DATA]
                        name=warlords
                        tldr=multi-player breakout
                        desc=stuff here
                        cmd={emu} {warlords}
                    /TAGS (touched 1 byte files...)
                        /action 
                        /pong
                        /multiplayer
                        /2d
                        /{whatever}
                    /GENRES
                        /breakout
                        /classic
                        /{whatever}
```