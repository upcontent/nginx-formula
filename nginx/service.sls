# nginx.service
#
# Manages the nginx service.

{% from 'nginx/map.jinja' import nginx, sls_block with context %}
{% set service_function = {True:'running', False:'dead'}.get(nginx.service.enable) %}

include:
  - nginx.install
  
nginx_service:
  service.{{ service_function }}:
    {{ sls_block(nginx.service.opts) }}
    - name: {{ nginx.lookup.service }}
    - enable: {{ nginx.service.enable }}
    - require:
      - sls: nginx.install
    - watch:
      {% if not nginx.install_from_source %}
      - pkg: nginx_install
      {% endif %}