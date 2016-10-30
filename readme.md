
![Zelda: Mystery of Solarus DX Logo](/data/logos/logo.png)

# Zelda: Mystery of Solarus DX

This package contains the data files of the game Zelda: Mystery of Solarus DX.
This quest is a free, open-source game that works with [Solarus](https://github.com/christopho/solarus),
an open-source Zelda-like 2D game engine.
To play this game, you need Solarus.
We assume in this readme that Solarus is already installed.

See our [development blog](http://www.solarus-games.org) to get more
information and documentation about Solarus and our games.

## Table of Contents
- [1. Play directly](#1-play-directly)
- [2. Install the quest](#2-install-the-quest)
	- [2.1. Default settings](#21-default-settings)
	- [2.2. Change the install directory](#22-change-the-install-directory)


## 1.  Play directly

You need to specify to the `solarus_run` binary the path of the quest data files
to use. The binary `solarus_run` accepts two forms of quest paths:
 - a directory having a subdirectory named `data` with all data inside,
 - a directory having a zip archive `data.solarus` with all data inside.

Thus, to run zsdx, if the current directory is the one that
contains the `data` subdirectory (and this readme), you can type:
```bash
$ solarus_run .
```
Or without arguments, if Solarus was compiled with the default quest set to `"."`:
```bash
$ solarus_run
```


## 2. Install the quest

###  2.1. Default settings

If you want to install zsdx, cmake and zip are recommended.
Just type:
```bash
$ cmake .
$ make
```

This generates the `data.solarus` archive that contains all data files
of the quest. You can then install it with
```bash
$ make install
```

This installs the following files (assuming that the install directory
is `/usr/local`):
- the quest data archive (`data.solarus`) in `/usr/local/share/solarus/zsdx/`
- a script called `zsdx` in `/usr/local/bin/`

The `zsdx` script launches `solarus_run` with the appropriate command-line argument
to specify the quest path.
This means that you can launch the zsdx quest with the command:
```bash
$ zsdx
```
which is equivalent to:
```bash
$ solarus_run /usr/local/share/solarus/zsdx
```


### 2.2. Change the install directory

You may want to install zsdx in another directory
(e.g. so that no root access is necessary).
You can specify this directory as a parameter of cmake:
```bash
$ cmake -D CMAKE_INSTALL_PREFIX=/home/your_directory .
$ make
$ make install
```
This installs the files described above, with the
`/usr/local` prefix replaced by the one you specified.
The script generated runs `solarus_run` with the appropriate quest path.
