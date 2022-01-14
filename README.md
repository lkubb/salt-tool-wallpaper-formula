# Wallpaper Formula
Sets wallpaper for users.

## Usage
Applying `tool-wallpaper` will make sure the wallpaper is configured as specified. Works on MacOS currently, Windows and Linux to come.

It syncs the pictures from a repo. See [Dotfiles](#dotfiles).

## Configuration
### Pillar
#### User-specific
The following shows an example of `tool-wallpaper` pillar configuration. Namespace it to `tool:users` and/or `tool:wallpaper:users`.
```yaml
user:
  xdg: true             # force xdg dirs (ie sync to ~/.local/share/wallpapers)
  dotconfig: true       # sync this user's wallpapers from a dotfiles repo available as
                        # salt://dotconfig/<user>/wallpapers or salt://dotconfig/wallpapers
  wallpaper:
    default: rather_sick_wallpaper.png
```

#### Formula-specific
```yaml
tool:
  wallpaper:
    defaults:           # default formula configuration for all users
      default: crazy_ass_wallpaper.jpeg
```

#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

### Dotfiles
`tool-wallpaper.configsync` will sync wallpapers from 

- `salt://dotconfig/<user>/wallpapers` or
- `salt://dotconfig/wallpapers`

to the user's target dir for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

## Todo
- add desktop-specific config (rather than all)
- add Linux
- add Windows
