# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as wallpapers with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in wallpapers.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}
{%-   set sources = files_switch(
            ["wallpapers"],
            lookup="Wallpapers configuration is synced for user '{}'".format(user.name),
            config=wallpapers,
            path_prefix="dotconfig",
            files_dir="",
            custom_data={"users": [user.name]},
      ) | load_json
%}
{%-   do sources.extend(
        files_switch(
            ["wallpapers"],
            lookup="Wallpapers configuration is synced for user '{}'".format(user.name),
            config=wallpapers,
            path_prefix="dotdata",
            files_dir="",
            custom_data={"users": [user.name]},
        ) | load_json
      )
%}

Wallpapers are synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_wallpapers"].datadir }}
    - source: {{ sources | json }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
{%- endfor %}
