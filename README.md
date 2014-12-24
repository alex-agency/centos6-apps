alex-centos6-apps
==========================

Docker Centos 6 Desktop applications


Build image dependencies:

```
# alexagency/centos6-desktop
```

To build image using boot2docker:

Copy the sources to following path:
MacOS: /Users/<USERNAME>/Docker/centos6-apps 
Windows: /c/Users/<USERNAME>/Docker/centos6-apps

```
# docker build --force-rm=true -t alexagency/centos6-apps /Users/Alex/Docker/centos6-apps
```

To run container in the background:

```
# docker run -d -p 5900:5900 -p 5901:5901 -p 3389:3389 alexagency/centos6-apps
or
# fig up -d
```

To run interactive with remove container after exit (--rm):

```
# docker run -it --rm -p 5900:5900 -p 5901:5901 -p 3389:3389 alexagency/centos6-apps
or
# fig up
```

VNC & RDP:

```
# 5900 root:centos, 5901 user:password
```

Show list of all containers:

```
# docker ps -a
```

To remove all stopeed containers:

```
# docker rm $(docker ps -a -q)
```

Show list of all images:

```
# docker images
```

To remove image by id:

```
# docker rmi -f <IMAGE ID>
```

To save repository:image to archive:

```
# docker save alex/centos6 > /Users/Alex/Desktop/alex_centos6.tar
```

To load repository from archive:

```
# docker load < /Users/Alex/Desktop/alex_centos6.tar
```
