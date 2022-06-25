<img 
  align="right"
  width="150"
  height="150"
  src="https://raw.githubusercontent.com/IonutParau/modularcm/main/logo.png"
/>

# ModularCM

ModularCM (pronounced "Modular-C-M"), is short for Modular Cell Machine.
It is focused on minimizing bloat by only having out of the box what is necessary and allowing the user to add the extra stuff.

## How do I run?

You can install Lua (version 5.1 or above), or LuaJIT, and simply run main.lua

## WHERE GUI??????

There is no GUI out of the box. You need a package for that.

## How do I add extra stuff someone else made?

Using the Module Package Manager (ModPM). Simply download the file of the package you want to add, and then launch the game and run

```
mod add <path to file>
```

Example:
You downloaded, let's say, "cool-gui.modpkg", and you want to add it.

You can simply move it to the folder where your game is at, and run (inside of the game's terminal)

```
mod add cool-gui.modpkg
```

### What if it is isn't a build file?

You can extract the contents of it as a folder and add it in `packages`.

## How do I compile my own package??

```
mod compile <package name>
```

## How do I play the game in the terminal?

You can use `set-cell`, `get-cell`, and `update` to play the game.
