# Dockerfile
This Dockerfile creates a container named "tomcatdev" which includes Tomcat 8.5, Maven 3.6.3 and Java 11.0.7 on Ubuntu 20.04 Focal OS.

## Usage

Put all files under the same folder. 
Download "jdk-11.0.7_linux-x64_bin.tar.gz" file from Oracle website and put it under the same folder.

Run below command to create docker image "demo/tomcat:8" 

```bash
docker build -f Dockerfile -t demo/tomcat:8 .
```
Run below command to create container "tomcatdev"

```bash
docker run -ti -d -p 127.0.0.1:9090:8080 --name tomcatdev -v "$PWD":/mnt/ demo/tomcat:8
```
As you can see, we expose 8080 port in Dockerfile. Tomcat will serve from port 8080 on container.
With above command, we bind port 8080 on container to the port 9090 on the host.

Open a browser, and type the URL as http://localhost:9090/ . You should be able to see the following page be loaded. Note the URL and the Tomcat version, 8.5.54

![all text](https://github.com/yasinunal/dockerfile/blob/master/tomcat_8.5.54.png)
