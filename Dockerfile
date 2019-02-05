FROM centos:6
MAINTAINER caoy@autoset.org

### wget, unzip, httpd 설치

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install wget unzip httpd && \
    yum clean all

## AdoptOpenJDK 8 설치

RUN	mkdir -p /opt/java ; \
	cd /opt/java ; \
	wget -q https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz ; \
	tar -xf OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz ; \
	rm -rf OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz ; \
	mv jdk8u202-b08 openjdk ; \
	export PATH=$PWD/openjdk/bin:$PATH

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

ENV JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

## Apache Tomcat 설치

RUN	cd /usr/local ; \
	wget -q http://apache.tt.co.kr/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz ; \
	tar -xf apache-tomcat-8.5.37.tar.gz ; \
	rm -rf apache-tomcat-8.5.37.tar.gz ; \
	mv apache-tomcat-8.5.37 tomcat ;\
	rm -rf tomcat/bin/*.bat

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

## Maven 설치

RUN	mkdir -p /usr/local/maven ; \
	wget -q https://apache.osuosl.org/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz ; \
	tar -xzf apache-maven-3.6.0-bin.tar.gz -C /usr/local/maven --strip-components=1 ; \
	rm -rf apache-maven-3.6.0-bin.tar.gz

ENV MAVEN_HOME /usr/local/maven
ENV MAVEN_CONFIG "/root/.m2"
ENV PATH $MAVEN_HOME/bin:$PATH

## Springboot demo 설치

RUN	cd /root ; \
	wget -q -O demo.zip "https://start.spring.io/starter.zip?type=maven-project&language=java&bootVersion=2.1.2.RELEASE&baseDir=demo&groupId=org.autoset&artifactId=demo&name=demo&description=Demo+project+for+Spring+Boot&packageName=org.autoset.demo&packaging=jar&javaVersion=1.8&autocomplete=&generate-project=&style=devtools&style=aop&style=web&style=actuator" ; \
	unzip demo.zip ; \
	rm -rf demo.zip ; \
	cd demo ; \
	mvn package


## 포트 개방

EXPOSE 80
EXPOSE 8080
