# vim: ft=sls

{#-
    Removes custom wallpapers.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as wallpapers with context %}


{%- for user in wallpapers.users %}

{%-   if user.xdg %}

Wallpapers data dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_wallpapers"].datadir }}
{%-   endif %}
{%- endfor %}
