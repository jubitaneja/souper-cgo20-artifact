This repository guides you to build the docker image for the artifact that we submitted to **CGO 2020**.

## Requirements
Souper should run on a modern Linux or OSX machine.
We tested our work on Ubuntu-18.04 version. Check
Ubuntu version:
```
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.3 LTS
Release:        18.04
Codename:       bionic
```

### Docker
Install docker engine by following the instructions
[here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

### Install prerequisite tools
```
$ ./prepare_req.sh
```

## Build docker image
```
$ ./build_docker.sh
```
