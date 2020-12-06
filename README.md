# docker-jupyterlab

## List of kernel

- Python3
- Ruby
- Julia


## How to use

```sh
$ git clone https://github.com/kyo1/docker-jupyterlab.git
$ cd docker-jupyterlab
$ mkdir -p notebook
$ make
```


## Use password

Attach to the container and execute the following command.

```sh
$ python -c 'from notebook.auth import passwd; print(passwd())'
```

Change `ACCESS_TOKEN` in `.env`.
