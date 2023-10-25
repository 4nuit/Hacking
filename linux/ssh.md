# SSH

## SSH usage

//TODO

## SSH key generation

```bash
ssh-keygen -t rsa -b 16384
```

- `-t` `rsa`|`ed25519` type de clef

- `-b` `16384` taille de la clef

- `-f` path

## SSH tunneling

```bash
ssh -gN -L 8000:127.0.0.1:8000 nicolas@192.168.122.42 -p 222
```

- `-g` Allow remote connection to connect to the local forwarded port

- `-N` do not open a prompt

- `-L` Forwarding port
  
  - `local_port:ip:distant_port`
