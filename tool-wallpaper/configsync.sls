{%- from 'tool-wallpaper/map.jinja' import wallpaper -%}

{%- for user in wallpaper.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

Wallpaper configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._wallpaper.datadir }}
    - source:
      - salt://dotconfig/{{ user.name }}/wallpapers
      - salt://dotconfig/wallpapers
      - salt://dotdata/{{ user.name }}/wallpapers
      - salt://dotdata/wallpapers
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
