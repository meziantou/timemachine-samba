FROM debian:13-slim@sha256:020c0d20b9880058cbe785a9db107156c3c75c2ac944a6aa7ab59f2add76a7bd

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        samba \
        samba-common-bin \
        ca-certificates \
        gettext-base \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data /etc/samba

COPY smb.conf.template /etc/samba/smb.conf.template
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 445/tcp

ENTRYPOINT ["/entrypoint.sh"]