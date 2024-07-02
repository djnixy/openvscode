# Use the base image
FROM gitpod/openvscode-server:latest

USER root # to get permissions to install packages and such

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    git \
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

USER openvscode-server # to restore permissions for the web interface
# Verify installations
RUN terraform --version && terramate --version

# # Expose the necessary port
# EXPOSE 3000

# # Set the working directory
# WORKDIR /config/workspace

# # Start the server
# CMD ["dumb-init", "/app/code-server/bin/code-server"]
