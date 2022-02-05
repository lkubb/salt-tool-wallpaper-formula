{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import wallpaper -%}

include:
  - {{ tplroot }}.configsync

{%- if 'Darwin' == grains.kernel %}
  {%- for user in wallpaper.users %}
Default wallpaper is configured for user {{ user.name }}:
  cmd.run:
    - name: |
        test -f "{{ user._wallpaper.datadir }}/{{ user.wallpaper.default }}" || exit 1
        osascript -e 'tell application "System Events" to tell every desktop to set picture to "{{ user._wallpaper.datadir }}/{{ user.wallpaper.default }}" as POSIX file'
    - runas: {{ user.name }}
    - require:
      - Wallpaper configuration is synced for user '{{ user.name }}'
  {%- endfor %}
{%- endif %}
