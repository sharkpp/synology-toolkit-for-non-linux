# syntax=docker/dockerfile:1

FROM ubuntu:20.04
WORKDIR /toolkit
# tzdate install prompt skip
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --fix-missing \
            python3 ca-certificates \
            git curl xz-utils \
            libpth-dev libksba-dev libgcrypt-dev libgpg-error-dev libassuan-dev zlib1g-dev wget bzip2 gcc make pinentry-tty
RUN mkdir -p /toolkit
RUN curl https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.31.tar.bz2 | tar jx ; \
    mv gnupg-* gnupg && cd gnupg && \
    ./configure && make && make install

FROM ubuntu:20.04
WORKDIR /toolkit
RUN apt-get update && apt-get install -y --fix-missing python3 ca-certificates xz-utils git libassuan0
COPY --from=0 /usr/local/share/gnupg /usr/local/share/gnupg
COPY --from=0 /usr/local/bin /usr/local/bin
COPY bootstrap.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/bootstrap.sh
RUN mkdir -p -m 0600 ~/.gnupg
RUN git clone https://github.com/SynologyOpenSource/pkgscripts-ng.git pkgscripts-DSM6
RUN git clone https://github.com/SynologyOpenSource/pkgscripts-ng.git pkgscripts-DSM7 ; cd pkgscripts-DSM7 ; git checkout DSM7.0
