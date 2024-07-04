# Use the base image
FROM gitpod/openvscode-server:latest

# to get permissions to install packages and such
USER root 

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
ARG TERRAFORM_VERSION=1.9.0
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

# Install Terramate
ARG TERRAMATE_VERSION=0.9.0
RUN wget https://github.com/terramate-io/terramate/releases/download/v${TERRAMATE_VERSION}/terramate_${TERRAMATE_VERSION}_linux_amd64.deb \
    && dpkg -i terramate_${TERRAMATE_VERSION}_linux_amd64.deb \
    && rm terramate_${TERRAMATE_VERSION}_linux_amd64.deb

# to restore permissions for the web interface
USER openvscode-server 
# Verify installations
RUN terraform --version && terramate --version

ARG HOME_PATH=/home
RUN touch ${HOME_PATH}/.bashrc \
    && echo "alias tm='terramate'" >> ~/.bashrc \
    && echo "alias tmplan='terramate generate && terramate run -- terraform init && terramate run -- terraform plan'" >> ${HOME_PATH}/.bashrc \
    && echo "alias tmapply='terramate generate && terramate run -- terraform init && terramate run -- terraform apply -auto-approve'" >> ${HOME_PATH}/.bashrc \
    && echo "alias tmdestroy='terramate run -- terraform destroy'" >> ${HOME_PATH}/.bashrc
RUN bash -c 'source ${HOME_PATH}/.bashrc'

# # Expose the necessary port
# EXPOSE 3000

# # Set the working directory
# WORKDIR /config/workspace

# # Start the server
# CMD ["dumb-init", "/app/code-server/bin/code-server"]
