# ansible_role_exporters

This playbook contain exporters for Prometheus:
- apache_exporter 
The following steps:
1. Running instalation script (if You need to specify version about releases, change 'VER' variable in `/scripts/apache_exporter.sh`) and creating daemon service.
2. Adding server-status to Apache configuration file, checking validate and reloading httpd service.
--------------------------
- grok_exporter
The following steps:
1. Running instalation script (if You need to specify version about releases, change 'VER' variable in `/scripts/apache_exporter.sh`) and creating daemon service.
2. Changing log-path and dir=path in grok conf. file
--------------------------
- mysqld_exporter
The following steps:
1. Running instalation script (if You need to specify version about releases, change 'VER' variable in `/scripts/mysqld_exporter.sh`) and creating daemon service.
2. Configuring database credentials and setting ownership permissions
--------------------------
- node_exporter
The following steps:
1. Running instalation script (if You need to specify version about releases, change 'VER' variable in `/scripts/node_exporter.sh`) and creating daemon service.
