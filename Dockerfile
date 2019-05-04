FROM centos:centos7.4.1708
ENV GOSU_VERSION 1.10
ENV GOSU_ARCH amd64
ENV GOSU_URL https://github.com/tianon/gosu/releases/download
ENV GOSU_APP ${GOSU_URL}/${GOSU_VERSION}/gosu-${GOSU_ARCH}
ENV GOSU_ASC ${GOSU_URL}/${GOSU_VERSION}/gosu-${GOSU_ARCH}.asc
ENV DB4_VERSION 4.8.30
ENV DB4_URL http://download.oracle.com/berkeley-db/db-${DB4_VERSION}.tar.gz

RUN set -x \
    && yum install -y epel-release \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN set -x \
    && yum install -y \
        gcc \
        gcc-c++ \
        make \
        curl-devel \
        libevent-devel \
        tcl-devel \
        tk-devel \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        ncurses-devel \
        readline-devel \
        gdbm-devel \
        file \
        libpcap-devel \
        xz-devel \
        expat-devel \
        snappy-devel \
        libevent-devel \
        libdb4-devel \
        libdb4-cxx-devel \
        zeromq-devel \
        gmp-devel \
        mpfr-devel \
        libmpc-devel \
        which \
        autoconf \
        automake \
        libtool \
        boost-devel \
        iproute \
        git \
        jq \
        python36 \
        wget \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN set -x \
    && adduser -m -s /sbin/nologin bitcoin \
    && chown bitcoin:bitcoin /home/bitcoin \
    && curl -o /usr/local/bin/gosu -SL ${GOSU_APP} \
    && curl -o /usr/local/bin/gosu.asc -SL ${GOSU_ASC} \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
        B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN set -x \
    && cd /usr/src \
    && git clone https://github.com/ElementsProject/elements.git \
    && wget ${DB4_URL} \
    && tar zxvf db-${DB4_VERSION}.tar.gz \
    && cd db-${DB4_VERSION}/build_unix \
    && ../dist/configure --prefix=/usr --enable-cxx \
        --disable-shared --with-pic \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && cd /usr/src \
    && rm -rf /usr/src/db-${DB4_VERSION}

RUN set -x \
    && cd /usr/src/elements \
    && ./autogen.sh \
    && ./configure --with-gui=no \
    && make \
    && make install \
    && make clean \
    && cd /usr/src \
    && rm -rf /usr/src/elements
 COPY ./docker-entrypoint.sh /
 ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elementsd"]

