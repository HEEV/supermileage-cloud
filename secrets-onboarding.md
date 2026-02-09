# Managing Secrets Overview
We use `age` for public/private key management and `sops` for our file encryption. Additionally, run-with-secrets.sh decrypts the usernames/passwords needed for the MQTT broker and entrypoint.sh creates the hashed password file needed when the docker container starts up.

## Install age
`sudo apt install age`
## Install SOPS (for linux)
- Go here for latest release: https://github.com/getsops/sops/releases

    - `curl -LO https://github.com/getsops/sops/releases/download/v3.11.0/sops-v3.11.0.linux.amd64`

    - `mv sops-v3.11.0.linux.amd64 /usr/local/bin/sops`

    - `sudo chmod +x /usr/local/bin/sops`

- for Windows installation:
    - Download the latest binary file 
    - Save it in a folder like Program Files (x86)\Sops\version-number
    - Rename the file to sops.exe
    - Add the path to the exe file to your PATH system variable

## Generate age keys
`age-keygen -o ~/.config/sops/age/keys.txt`

- Keep the private key safe on your machine
- copy the public key to secrets/.sops.yaml
- run `sops updatekeys mosquitto/secrets/dev.yaml`


## To add/remove subscribers/publishers to the dev.yaml file:
- `sops mosquitto/secrets/dev.yaml` opens the dev.yaml file in a vim editor that will encrypt upon saving the file. 
- The topics for any new members must be added to the mosquitto/config/acl file
