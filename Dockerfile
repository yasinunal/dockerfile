FROM ubuntu:20.04

MAINTAINER yasin.unal.83@gmail.com

RUN apt-get update
RUN apt-get upgrade
RUN apt-get -qq -y install curl
RUN apt-get install -y pwgen

RUN mkdir /usr/lib/jvm/
WORKDIR /usr/lib/jvm
COPY ./jdk-11.0.7_linux-x64_bin.tar.gz /usr/lib/jvm/
RUN sha256sum jdk-11.0.7_linux-x64_bin*
RUN tar -zxf jdk-11.0.7_linux-x64_bin.tar.gz
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11.0.7/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11.0.7/bin/javac 100
RUN apt-get update
ENV JAVA_VER 11
ENV JAVA_HOME /usr/lib/jvm/jdk-11.0.7
RUN java -version

ENV MAVEN_VERSION 3.6.3
RUN mkdir -p /usr/share/maven \
	&& curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
	| tar -xzC /usr/share/maven --strip-components=1 \
	&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
VOLUME /root/.m2

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.5.54
RUN mkdir /opt/tomcat/
ENV CATALINA_HOME /opt/tomcat
WORKDIR /opt/tomcat
RUN curl -OL https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.54/bin/apache-tomcat-8.5.54.tar.gz
RUN tar -zxf apache-tomcat-8.5.54.tar.gz
RUN mv apache-tomcat-8.5.54/* /opt/tomcat/.
ADD create_tomcat_admin_user.sh /opt/tomcat/bin/create_tomcat_admin_user.sh
RUN chmod +x /opt/tomcat/bin/create_tomcat_admin_user.sh
RUN chmod +x /opt/tomcat/conf/tomcat-users.xml
RUN /opt/tomcat/bin/create_tomcat_admin_user.sh

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]