# docker-jupyterlab

## List of kernel

- Python3
- Ruby
- Julia


## How to use

```sh
$ git clone https://github.com/kyo1/docker-jupyterlab.git
$ cd docker-jupyterlab
$ docker-compose up
```


## Update container

```sh
$ docker-compose stop
$ docker-compose build
$ docker-compose up
```


## Use password

Attach to the container and execute the following command.

```sh
$ python -c 'from notebook.auth import passwd; print(passwd())'
```

Change `ACCESS_TOKEN` in `.env`.
