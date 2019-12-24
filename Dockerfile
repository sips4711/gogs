FROM centos:7

ARG GOGS_BUILD=49

LABEL name="Gogs - Go Git Service" \
      vendor="Gogs" \
      io.k8s.display-name="Gogs - Go Git Service" \
      io.k8s.description="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      summary="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      io.openshift.expose-services="3000,gogs" \
      io.openshift.tags="gogs" \
      release="1"

ENV HOME=/var/lib/gogs

COPY ./root /

RUN curl -L -o /etc/yum.repos.d/gogs.repo https://dl.packager.io/srv/pkgr/gogs/pkgr/installer/el/7.repo && \
    yum -y install epel-release && \
    yum -y --setopt=tsflags=nodocs install nss_wrapper gettext && \
    curl -L -o /tmp/gogs.rpm  https://packager.io/gh/gogs/gogs/builds/${GOGS_BUILD}/download/centos-7 && \
    yum -y localinstall /tmp/gogs.rpm && \
    yum -y clean all && \
    mkdir -p /var/lib/gogs

RUN /usr/bin/fix-permissions /var/lib/gogs && \
    /usr/bin/fix-permissions /home/gogs && \
    /usr/bin/fix-permissions /opt/gogs && \
    /usr/bin/fix-permissions /etc/gogs && \
    /usr/bin/fix-permissions /var/log/gogs

EXPOSE 3000
USER 997

CMD ["/usr/bin/rungogs"]
