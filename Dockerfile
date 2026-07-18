FROM debian:13-slim

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