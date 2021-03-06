FROM ubuntu:14.04
MAINTAINER liudanking <liudanking@gmail.com>

RUN apt-get update
RUN apt-get install build-essential libwrap0-dev libpam0g-dev libdbus-1-dev libreadline-dev libnl-route-3-dev  libpcl1-dev libopts25-dev autogen libgnutls28 libgnutls28-dev libseccomp-dev iptables wget vim gnutls-bin libprotobuf-c0-dev protobuf-c-compiler libprotobuf-dev protobuf-compiler libprotoc-dev libtalloc-dev libhttp-parser-dev -y

RUN apt-get install libxml2-dev -y

RUN wget https://github.com/radcli/radcli/releases/download/1.2.4/radcli-1.2.4.tar.gz && tar vxf radcli-1.2.4.tar.gz && cd radcli-1.2.4 && ./configure --prefix=/usr && make && make install

RUN cd /root && wget http://www.infradead.org/ocserv/download.html && export ocserv_version=0.10.9 \
	&& wget ftp://ftp.infradead.org/pub/ocserv/ocserv-$ocserv_version.tar.xz && tar xvf ocserv-$ocserv_version.tar.xz \
	&& cd ocserv-$ocserv_version && ./configure --prefix=/usr --sysconfdir=/etc --with-local-talloc --with-radius && make && make install \
	&& rm -rf /root/download.html && rm -rf ocserv-*

WORKDIR /etc/ocserv
