# update and upgrade system
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y gnupg software-properties-common
wait 200

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update -y
wait 30
sudo apt-get install terraform -y
wait 100

# call terraform init to download the providers packages from terraform registry
terraform init
wait 30

# folder for caching the terraform providers
mkdir "$HOME/tf_cache"
mv "$HOME/.terraformrc" "$HOME/tf_cache"

export TF_PLUGIN_CACHE_DIR="$HOME/tf_cache"
export TF_CLI_CONFIG_FILE="$HOME/tf_cache/.terraformrc"

# move the packages to tf_cache
mv "$HOME/.terraform/providers/registry.terraform.io" "$HOME/tf_cache"

# TODO: remember to disable internet access after this



