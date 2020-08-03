# ansible_role_firewall

Just simple playbook to adding rule to iptables and install iptables-persistent, fail2ban packages.
In this case it's allowing 10050 (zabbix-agent port)

Make sure to correct port and `source:` in playbook.yml
