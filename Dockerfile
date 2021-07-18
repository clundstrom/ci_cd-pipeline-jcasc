FROM jenkins/jenkins:lts-jdk11 as pipeline

USER root

RUN apt-get update && apt-get install -y curl

# Extract docker client
ENV DOCKERVERSION=19.03.8
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# Config as Code (CASC)
COPY pipeline/casc.yaml /var/jenkins_home/casc.yaml
COPY pipeline/plugins.txt /usr/share/jenkins/ref/plugins.txt

# Plugins used as input to CasC
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN groupadd docker && gpasswd -a jenkins docker
USER jenkins