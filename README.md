# Cities server


### Description
Entrypoint of demo project


### Docker images
Docker images can public only maintainer of this project.
```shell
chmod +x server.sh
sh server.sh --publish
```


### Work with server
server.sh work with aws server and has commands:
- `--help` - display description of commands
- `--publish` - publish docker image
- `--deploy` - deploy on the server by SSH file (six-cities.pem)
- `--connect` - connect to server
- `--up` - up docker containers
- `--down` - down docker containers
- `--update` - pull all changed images


### Environments
Should contain environments directory with files:
- [api.env](https://registry.hub.docker.com/repository/docker/kvezal/cities-api)
- [postgres.env](https://hub.docker.com/repository/docker/kvezal/cities-postgres)

