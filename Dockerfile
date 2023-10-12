FROM ubuntu:22.04

# Install ansible and sshpass
RUN apt-get update
RUN apt-get install ansible -y
RUN apt-get install sshpass -y

# Copy ansible config
COPY ./.config/ansible.cfg /etc/ansible/ansible.cfg

# Set user and group
ARG user=svcansible
ARG group=svcansible
ARG privateKey=id_ed25519
ARG uid=1000
ARG gid=1000

# Create user and group
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user}

# Copy ssh key and set permissions
RUN mkdir /home/${user}/.ssh
COPY .secret/${privateKey} /home/${user}/.ssh/${privateKey}
RUN chmod 700 /home/${user}/.ssh
RUN chmod 400 /home/${user}/.ssh/${privateKey}
RUN chown -R ${user}:${user} /home/${user}

# Switch to user
USER ${uid}:${gid}

# Set working directory
WORKDIR /home/${user}
