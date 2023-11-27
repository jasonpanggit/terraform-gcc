# bin/bash

# update
apt-get update \
    && apt-get install -y \
        curl \
        git \
        gnupg \
        python3-dev \
        python3-gssapi \
        python3-pip \
        python3-netaddr \
        python3-jmespath \
        python3-setuptools \
        python3-wheel \
        python3-pymssql \
        software-properties-common \
        unzip \
        wget

# install ansible and jinja2
pip install ansible ansible-lint Jinja2

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

apt-get update && apt-get install -y terraform

# install azure cli
curl -sL https://aka.ms/InstallAzureCLIDeb | bash