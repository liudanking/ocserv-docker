FROM ubuntu:trusty
MAINTAINER liudanking <liudanking@gmail.com>

RUN apt-get update
RUN apt-get install build-essential libwrap0-dev libpam0g-dev libdbus-1-dev libreadline-dev libnl-route-3-dev  libpcl1-dev libopts25-dev autogen libgnutls28 libgnutls28-dev libseccomp-dev iptables wget vim gnutls-bin libprotobuf-c0-dev protobuf-c-compiler libprotobuf-dev protobuf-compiler libprotoc-dev libtalloc-dev libhttp-parser-dev -y

RUN apt-get install libxml2-dev  -y

RUN wget https://github.com/radcli/radcli/releases/download/1.2.4/radcli-1.2.4.tar.gz && tar vxf radcli-1.2.4.tar.gz && cd radcli-1.2.4 && ./configure --prefix=/usr && make && make install

RUN cd /root && wget http://www.infradead.org/ocserv/download.html && export ocserv_version=$(cat download.html | grep -o '[0-9]*\.[0-9]*\.[0-9]*') \
	&& wget ftp://ftp.infradead.org/pub/ocserv/ocserv-$ocserv_version.tar.xz && tar xvf ocserv-$ocserv_version.tar.xz \
	&& cd ocserv-$ocserv_version && ./configure --prefix=/usr --sysconfdir=/etc --with-local-talloc --with-radius && make && make install \
	&& rm -rf /root/download.html && rm -rf ocserv-*

ADD ./certs /opt/certs
RUN certtool --generate-privkey --outfile /opt/certs/ca-key.pem && certtool --generate-self-signed --load-privkey /opt/certs/ca-key.pem --template /opt/certs/ca-tmp --outfile /opt/certs/ca-cert.pem && certtool --generate-privkey --outfile /opt/certs/server-key.pem && certtool --generate-certificate --load-privkey /opt/certs/server-key.pem --load-ca-certificate /opt/certs/ca-cert.pem --load-ca-privkey /opt/certs/ca-key.pem --template /opt/certs/serv-tmp --outfile /opt/certs/server-cert.pem

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

WORKDIR /etc/ocserv
CMD ["vpn_run"]
