# docker-compose-jupyterlab

## List of kernel

- Python3
- Ruby
- Julia


## How to use

```sh
$ git clone https://github.com/kyo1/docker-compose-jupyterlab.git
$ cd docker-compose-jupyterlab
$ docker-compose up
```


## Update container

```sh
$ docker-compose stop
$ docker-compose build
$ docker-compose up
```


## Change password

Attach to the container and execute the following command.

```sh
$ python3 -c "from jupyter_server.auth import passwd; print(passwd())"
```

Change `ACCESS_TOKEN` in `.env`.
