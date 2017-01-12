# docker-jupyter

Jupyter Notebook Docker image.

## Quick start

Clone this repository and build the Docker image.

```shell
$ git clone git@ssh.github.com:nVentiveUX/docker-jupyter.git
$ cd docker-jupyter
# With a proxy, add "--build-arg http_proxy=http://$(hostname):3128/ --build-arg https_proxy=http://$(hostname):3128/"
$ docker build --force-rm -t nventiveux/docker-jupyter -t nventiveux/docker-jupyter:1.0.0 .
```

Test the container

```shell
$ docker run --rm \
  --name jupyter_$USER \
  --user 1000:1000 \
  -h $(hostname)_jupyter_$USER \
  -p 8888:8888 \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v ~/.ssh:/tmp/.ssh \
  -v /etc/passwd:/etc/passwd:ro \
  -v $(pwd):/notebooks nventiveux/docker-jupyter-tigerplm:latest
```

Run the container

```shell
$ {
sudo cp systemd/docker-jupyter@.service /etc/systemd/system/ &&
sudo cp systemd/docker-jupyter@.default /etc/default/docker-jupyter@$USER &&
sudo systemctl daemon-reload &&
sudo systemctl enable docker-jupyter@$USER.service;
}
```

Provide notebooks to run

```shell
$ sudo vi /etc/default/docker-jupyter@$USER
```

Start Jupyter

```shell
$ {
sudo systemctl start docker-jupyter@$USER.service &&
sudo systemctl status -l docker-jupyter@$USER.service;
}
```
