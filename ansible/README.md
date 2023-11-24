# Setup
1. Install ansible (sudo apt-get install ansible -y)
2. Install ansible-lint (sudo apt-get install ansible-lint -y)
3. Install Jinja2 (pip install Jinja2)

# How to render landing zone tfvars
1. Update landing-zone-config.yml
2. Run ansible-playbook /home/jason/terraform-gcc/ansible/landing-zone-render.yml