#ansible_role_exporters

This playbook contain exporters for Prometheus:
- apache_exporter 
The following steps is:
1. Running instalation script (if You need to specify version about releases, change 'VER' variable in `/scripts/apache_exporter.sh`) and creating daemon service.
2. Adding server-status to Apache configuration file, checking validate and reloading httpd service.
