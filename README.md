Inspired by the [headless vnc container](https://github.com/consol/docker-headless-vnc-container) by [Consol](https://labs.consol.de/)

# Quickstart
Run the following commands:
  ```
  chmod +x build.sh
  ./build.sh
  chmod +x run.sh
  ./run.sh
  ```

Then open a web browser at `localhost:6901/vnc.html` and paste the password generated from `run.sh`.

If you want to setup git run `b-git-setup`

# Ubuntu based Docker container image with "headless" VNC session

This repository contains a headless ubuntu Docker image with the following components:

* Desktop environment [**Xfce4**](http://www.xfce.org)
* VNC-Server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* Mozilla Firefox and Chromium Browsers.

## Usage
- Build image from scratch:

      ./build.sh

- Search for build errors:

      grep -E -- 'error|fail|warning' "./logs/some_name_build.log"

- Run container:

      ./run.sh

- Check container status:

  docker ps
  
- Log into root cli:

  docker exec -it perennial /bin/bash

- Stop perennial container:

  docker stop perennial

- Restart container:

  docker start perennial

## Connect & Control
If the container is started like mentioned above, connect via one of these options:

* connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 

## Notes

### Extend the image with your own software
By default, the image runs as a non-root user. If you want to extend the image and install software, you have to switch back to the `root` user:

```bash
# Custom Dockerfile
FROM perennial

# Switch to root user (UID 0) to install additional software
USER 0

# Install a package
RUN apt-get install -y gedit \
    && apt-get clean -y

# switch back to default normal user (UID 1000)
USER 1000
```

### Change User of running Container

By default, all container processes will be executed with user id `1000`. You can change the user id by adding the `--user` flag to your docker run command. 

To change to the root user (user id `0`):

    docker run -it --user 0 -p 6901:6901 perennial

To change to the user and group id of host system:

    docker run -it -p 6901:6901 --user $(id -u):$(id -g) perennial

### Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1280x1024`
* `VNC_PW`, default: `my-pw`

To override the VNC password:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=my-pw perennial

To override the VNC resolution:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 perennial

### Suggested usage

Generate random password and run in high resolution:

```
  export RANDOM_PASSWORD=$(openssl rand -hex 10) && \
  docker run -d --shm-size=256m -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=1920x1080 -e VNC_PW=$RANDOM_PASSWORD perennial && \
  echo "Generated password is: $RANDOM_PASSWORD" && \
  unset RANDOM_PASSWORD
```

On mac, you can login via screenshare with this command:
```
  open vnc://localhost:5901
```

### Known Issues

#### Chromium crashes with high VNC_RESOLUTION
If you open some graphic/work intensive websites in the Docker container (especially with high resolutions e.g. `1920x1080`) Chromium can sometimes crash without any specific reason. The problem there is the `/dev/shm` is too small in the container. Currently, the only solution is to define this size on startup via `--shm-size`:

    docker run --shm-size=256m -it -p 6901:6901 -e VNC_RESOLUTION=1920x1080 perennial chromium-browser http://map.norsecorp.com/

## How to release
* Check if all features are merged and pushed
* Pull the latest image: `.build/tag_image.sh dev 1.x.x --save`
* Test if the latest build is usable
* On success - push the tested image to dockerhub
```
      ./tag_image.sh dev 1.x.x
      ./tag_image.sh dev latest
```
* Merge to `master`
* Create a release on [github.com/vorprog/headless-vnc-container/releases/new](https://github.com/vorprog/headless-vnc-container/releases/new)

### File Transferring

Copy a file from container to host:
```
docker cp <CONTAINER ID:/home/user/foo.txt ./foo.txt
```

Copy a file from host to container:
```
docker cp foo.txt <CONTAINER ID>:/home/user/foo.txt
```

## Kubernetes

It's also possible to run the images in the [Kubernetes](https://kubernetes.io) container orchestration platform. For more information how to deploy containers in the cluster, take a look at:

### Deploy one pod of `perennial` image and expose a service
 
On an already logged in Kubernetes cluster just use the predefined deployment with service config [`deployment.yaml`](deployment.yaml): 

    kubectl apply -f  deployment.yaml
    
Now a new pod with corresponding service should spin up with `ContainerCreating`:

```bash
kubectl get pods --output=wide
```    

After a while the kublet will have downloaded the imaged and started - this will show as STATUS `Running`.

Due to the following service configuration, the service will be exposed as type `NodePort`, this means that the service will accessible through the IP of the Kubernetes node and the exposed `nodePort`.

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    application: headless-vnc
  name: headless-vnc
spec:
  externalName: headless-vnc
  ports:
  - name: http-port-tcp
    protocol: TCP
    port: 6901
    targetPort: 6901
    nodePort: 32001
#...
  selector:
    application: headless-vnc
  type: NodePort

```

Then you can connect to the pod via [http://<ip-of-node>:32001/?password=vncpassword](http://<ip-of-node>:32001/?password=vncpassword).

### Delete deployment

Execute the command:

    kubectl delete -f deployment.yaml