{%- from 'tool-wallpaper/map.jinja' import wallpaper -%}

{%- for user in wallpaper.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
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
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
