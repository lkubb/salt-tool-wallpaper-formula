# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as wallpapers with context %}


include:
  - {{ tplroot }}.config.sync

{%- if grains.kernel == "Darwin" %}
{%-   for user in wallpapers.users | selectattr("wallpapers.default", "defined") %}
{%-     set default_wallpaper = user._wallpapers.datadir | path_join(user.wallpapers.default) %}

Default wallpaper is configured for user '{{ user.name }}':
  cmd.run:
    - name: |
        test -f '{{ default_wallpaper }}' || exit 1
        osascript -e 'tell application "System Events" to tell every desktop to set picture to "{{ default_wallpaper }}" as POSIX file'
    - runas: {{ user.name }}
    - unless:
      - test "$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')" = '{{ default_wallpaper }}'
    - require:
      - Wallpapers are synced for user '{{ user.name }}'
  {%- endfor %}
{%- endif %}
