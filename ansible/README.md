# How to generate and use landing zone tfvars file
1. update landing-zone-config.yml and landing-zone-template.j2 accordingly
2. cd ..
3. run "ansible-playbook ansible/landing-zone-render.yml"
4. run "terraform fmt" to format the generated tfvars
5. run "terraform plan -var-file generated-landing-zone.tfvars"
6. run "terraform apply -var-file generated-landing-zone.tfvars --auto-approve"