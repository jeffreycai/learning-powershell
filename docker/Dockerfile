FROM mcr.microsoft.com/powershell

ARG UID=1000
ARG GID=1000
ARG USERNAME=ec2-user
ARG GROUPNAME=ec2-user

## install packages
RUN apt update && apt-get install -y \
    systemctl \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    python3-pip

## Add Docker CE repository and install Docker CE CLI
#RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
#    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
#    && apt-get update \
#    && apt-get install -y docker-ce-cli

### create new users and add to sudoers
RUN addgroup --gid ${GID} --system ${GROUPNAME} || true
RUN adduser --uid ${UID} --system ${USERNAME} --ingroup ${GROUPNAME}
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN addgroup ${USERNAME} root
RUN chsh -s /bin/bash ${USERNAME}  # Changed jeffreycai to ${USERNAME}

### install ansible version 2.10.7
RUN python3 -m pip install ansible==2.10.7 \
    && python3 -m pip install ansible-vault

## install other system packages
RUN apt install -y vim

USER ${USERNAME}
### ssh configs
WORKDIR /home/${USERNAME}
RUN mkdir -p .ssh
RUN touch .ssh/config

COPY id_rsa /home/${USERNAME}/.ssh/id_rsa
COPY ansible_vault_password /home/${USERNAME}/.ssh/ansible_vault_password
RUN cd /home/${USERNAME}/.ssh \
    && ansible-vault decrypt id_rsa --vault-password-file ansible_vault_password \
    && chmod 600 id_rsa \
    && rm ansible_vault_password

# Azure initialization
RUN pwsh -Command "Install-Module -Name Az -AllowClobber -Repository PSGallery -Force"


USER root

## others
RUN mkdir -p /opt/app
WORKDIR /opt/app
