alex-centos6-apps
==========================

Docker Centos 6 Desktop applications

![apps](https://cloud.githubusercontent.com/assets/1122708/10214796/1b0b53cc-6824-11e5-841d-b9eba57731b8.jpg)

Create dev workstation

```
docker-machine create -d virtualbox dev
```

Get IP address

```
docker-machine ip dev
```

Connect Docker

```
eval "$(docker-machine env dev)"
```

Copy the sources to following path:
MacOS: /Users/<USERNAME>/Docker/centos6-apps 
Windows: /c/Users/<USERNAME>/Docker/centos6-apps

Build image

```
docker-machine ssh dev
cd /Users/<USERNAME>/Docker/centos6-apps
cd /c/Users/<USERNAME>/docker/centos6-apps
docker build --force-rm=true -t alexagency/centos6-apps .
```

Run container in the background

```
docker run -d -p 5900:5900 -p 5901:5901 -p 3389:3389 alexagency/centos6-apps
```

Run container interactive with remove container after exit (--rm)

```
docker run -it --rm -p 5900:5900 -p 5901:5901 -p 3389:3389 alexagency/centos6-apps
```

VNC & RDP:

```
5900 root:centos, 5901 user:password
```

Show list of all containers:

```
docker ps -a
```

To remove all stopeed containers:

```
docker rm $(docker ps -a -q)
```

Show list of all images:

```
docker images
```

To remove image by id:

```
docker rmi -f <IMAGE ID>
```

To save repository:image to archive:

```
docker save alexagency/centos6-apps > /Users/<USERNAME>/Desktop/centos6-apps.tar
```

To load repository from archive:

```
docker load < /Users/<USERNAME>/Desktop/centos6-apps.tar
```
