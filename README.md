# Some simple playbooks to automating various tasks

### ansible_role_exporters
There are some useful roles contain few exporters for Prometheus:
- node_exporter
- apache_exporter
- mysqld_exporter
- grok_exporter (experimental)

All roles have a common task. Add proxy_pass to exporters.conf webserver file (NGiNX) to serve metrics, sth like this:

`#APACHE_EXPORTER
location /apache_exporter/metrics {
proxy_pass      http://127.0.0.1:9117/metrics; }

#NODE_EXPORTER
location /node_exporter/metrics {
proxy_pass      http://127.0.0.1:9100/metrics; }`

--------------------------
### ansible_role_firewall
Simple playbook to adding a rule in iptables

### ansible_role_nginx_apt
Mass install and verify latest NGiNX using apt (i.e. for Debian, Ubuntu)

### ansible_role_nginx_yum
Mass install and verify latest NGiNX using yum (i.e. for Centos) and add more general nginx config' from template (check this in ansible_role_nginx_yum/templates/nginx.conf)

### ansible_role_zabbix
Make install zabbix-agents on your own machines and customize their config to connect your Zabbix server

### create_admin_accounts
Simple playbook to creating new users, adding their publick ssh-rsa key, setting their groups and adding sudo priviligies to them without password confirmation

### create_ansible_account
Use this when You need to created mass user for automation with ansible on your hosts (more information - see README)
