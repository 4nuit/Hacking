#!/bin/bash
docker rm $(docker ps -aq)
docker rmi rsa_wiener-ssh_server
