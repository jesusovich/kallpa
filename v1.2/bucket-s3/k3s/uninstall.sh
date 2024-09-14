# Correr los comandos dentro del folder k3s-ansible.

# Uninstall Servers

ansible server -b -m shell -a "/usr/local/bin/k3s-uninstall.sh"

# Uninstall Agents

ansible agent -b -m shell -a "/usr/local/bin/k3s-agent-uninstall.sh"