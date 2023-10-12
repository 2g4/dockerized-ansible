# Dockerized Ansible

## Prerequisites

1.  Generate ed25519 SSH key pair

    ```bash
    ssh-keygen -t ed25519 -f {YOUR_PATH} -C "svcanisble"
    ```

2.  Copy the private key to `.secret` folder

    ```bash
    cp {YOUR_PATH} .secret/id_ed25519
    ```

## Providing Ansible access to remote hosts

1. Create `svcanisble` user on remote host.
2. Add `svcanisble` user to `sudoers` group.
3. Add `svcanisble` user's public key (./config/pub-ed25519.key) to `authorized_keys` file.

## Helpers

| Script       | Description            |
| ------------ | ---------------------- |
| run.build.sh | Build image            |
| run.sh       | SSH into the container |

## Examples

Echo test

```bash
ansible-playbook playbook/echotest.yml -i inventory/test.ini -K
```

## Other

1. In case the private hey has a passphrase

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

You will be prompted to enter the passphrase.

2. The example uses ed25519 SSH Key, if you want to use RSA key, you need to change the following files:

   - .secret/id_ed25519 -> .secret/id_rsa
   - Dockerfile:<br>
     <code>
     ARG privateKey=<strike>id_ed25519</strike><br>
     ARG privateKey=id_rsa
     </code>

3. The image supports hot reloading of playbooks, allowing you to just rerun the command after any changes, and it will execute with the updated playbook.
